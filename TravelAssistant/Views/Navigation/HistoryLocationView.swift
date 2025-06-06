import SwiftUI
import MapKit
import CoreLocation

struct HistoryLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var historyManager: HistoryLocationManager
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var locationManager: LocationManager
    @State private var selectedTab = 0
    @State private var showingClearConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 分段控制器
                Picker("History Options", selection: $selectedTab) {
                    Text("Recent Visits").tag(0)
                    Text("Frequency").tag(1)
                    Text("All Records").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if historyManager.historyLocations.isEmpty {
                    // 空状态
                    VStack(spacing: 16) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No history records")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Start using navigation, your destination will appear here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 历史记录列表
                    List {
                        ForEach(getFilteredLocations()) { location in
                            HistoryLocationRow(
                                location: location,
                                userLocation: locationManager.location
                            ) {
                                // 选择历史地点作为目的地
                                selectLocation(location)
                            }
                        }
                        .onDelete { indexSet in
                            let locationsToDelete = getFilteredLocations()
                            let idsToDelete = indexSet.map { locationsToDelete[$0].id }
                            
                            historyManager.historyLocations.removeAll { location in
                                idsToDelete.contains(location.id)
                            }
                            if let encoded = try? JSONEncoder().encode(historyManager.historyLocations) {
                                UserDefaults.standard.set(encoded, forKey: "history_locations")
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("History Locations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !historyManager.historyLocations.isEmpty {
                        Button("Clear") {
                            showingClearConfirmation = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Clear History", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                historyManager.clearHistory()
            }
        } message: {
            Text("Are you sure you want to clear all history locations? This action cannot be undone.")
        }
    }
    
    // 根据选择的tab获取过滤后的地点列表
    private func getFilteredLocations() -> [HistoryLocation] {
        switch selectedTab {
        case 0: // 最近访问
            return historyManager.getRecentLocations(limit: 20)
        case 1: // 访问频次
            return historyManager.getFrequentLocations(limit: 20)
        case 2: // 全部记录
            return historyManager.historyLocations
        default:
            return historyManager.historyLocations
        }
    }
    
    // 选择地点
    private func selectLocation(_ location: HistoryLocation) {
        // 停止当前导航（如果有的话）
        if mapViewModel.isNavigating {
            mapViewModel.stopNavigation()
        }
        
        // 清除现有路线
        mapViewModel.clearRoute()
        
        // 设置为新的目的地（覆盖旧目的地）
        mapViewModel.selectDestination(
            coordinate: location.coordinate,
            title: location.name
        )
        
        // 创建MKMapItem并计算路线
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        
        mapViewModel.calculateRouteAndStartNavigation(to: mapItem)
        
        // 再次添加到历史记录（更新访问次数）
        historyManager.addHistoryLocation(
            name: location.name,
            address: location.address,
            coordinate: location.coordinate
        )
        
        dismiss()
    }
}

// 历史地点行视图
struct HistoryLocationRow: View {
    let location: HistoryLocation
    let userLocation: CLLocation?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(location.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(formatVisitTime(location.visitedAt))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        if location.visitCount > 1 {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text("\(location.visitCount) times")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let distance = calculateDistance() {
                        Text(formatDistance(distance))
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func calculateDistance() -> CLLocationDistance? {
        guard let userLocation = userLocation else {
            return nil
        }
        
        let locationCL = CLLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        return userLocation.distance(from: locationCL)
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f meters", distance)
        } else {
            return String(format: "%.1f kilometers", distance / 1000)
        }
    }
    
    private func formatVisitTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            formatter.dateFormat = "HH:mm"
            return "今天 \(formatter.string(from: date))"
        } else if calendar.isDate(date, inSameDayAs: Date().addingTimeInterval(-86400)) {
            formatter.dateFormat = "HH:mm"
            return "昨天 \(formatter.string(from: date))"
        } else if calendar.dateInterval(of: .weekOfYear, for: Date())?.contains(date) == true {
            formatter.dateFormat = "E HH:mm"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: date)
        }
    }
} 