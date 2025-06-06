//
//  RouteOptionsView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI
import MapKit

struct RouteOptionsView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTransportType: MKDirectionsTransportType
    @State private var avoidTolls = false
    @State private var avoidHighways = false
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        self._selectedTransportType = State(initialValue: mapViewModel.routeTransportType)
        self._avoidTolls = State(initialValue: mapViewModel.avoidTolls)
        self._avoidHighways = State(initialValue: mapViewModel.avoidHighways)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 交通方式选择
                    transportTypeSection
                    
                    // 路线偏好设置
                    if selectedTransportType == .automobile {
                        routePreferencesSection
                    }
                    
                    // 当前路线信息
                    if let route = mapViewModel.currentRoute {
                        currentRouteSection(route)
                    }
                    
                    // 备选路线
                    if !mapViewModel.alternativeRoutes.isEmpty {
                        alternativeRoutesSection
                    }
                    
                    // 应用按钮
                    applyButton
                }
                .padding()
            }
            .navigationTitle("Route options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        applyChanges()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - 视图组件
    
    private var transportTypeSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Transport type")
                .font(.headline)
            
            VStack(spacing: 10) {
                TransportTypeRow(
                    type: .automobile,
                    icon: "car.fill",
                    title: "Drive",
                    subtitle: "Recommended fastest route",
                    isSelected: selectedTransportType == .automobile
                ) {
                    selectedTransportType = .automobile
                }
                
                TransportTypeRow(
                    type: .walking,
                    icon: "figure.walk",
                    title: "Walk",
                    subtitle: "Suitable for short distance travel",
                    isSelected: selectedTransportType == .walking
                ) {
                    selectedTransportType = .walking
                }
                
                TransportTypeRow(
                    type: .transit,
                    icon: "tram.fill",
                    title: "Metro/Bus",
                    subtitle: "Bus, subway and rail routes (limited coverage)",
                    isSelected: selectedTransportType == .transit
                ) {
                    selectedTransportType = .transit
                }
            }
        }
    }
    
    private var routePreferencesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Route preferences")
                .font(.headline)
            
            VStack(spacing: 0) {
                PreferenceRow(
                    title: "Avoid toll roads",
                    subtitle: "Choose free routes",
                    isOn: $avoidTolls
                )
                
                Divider()
                    .padding(.leading, 50)
                
                PreferenceRow(
                    title: "Avoid highways",
                    subtitle: "Choose ordinary roads",
                    isOn: $avoidHighways
                )
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
    
    private func currentRouteSection(_ route: MKRoute) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Current route")
                .font(.headline)
            
            RouteInfoCard(
                route: route,
                title: "Recommended route",
                isSelected: true,
                showDetails: true
            ) {
                // 当前路线不需要选择操作
            }
            
            // 公交换乘详情
            if selectedTransportType == .transit {
                transitDetailsSection(route)
            }
        }
    }
    
    // 公交换乘详情
    private func transitDetailsSection(_ route: MKRoute) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "tram.fill")
                    .foregroundColor(.blue)
                Text("Transfer details")
                    .font(.headline)
            }
            
            VStack(spacing: 8) {
                ForEach(Array(route.steps.enumerated()), id: \.offset) { index, step in
                    TransitStepView(step: step, stepNumber: index + 1)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var alternativeRoutesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Alternative routes")
                .font(.headline)
            
            ForEach(mapViewModel.alternativeRoutes.indices, id: \.self) { index in
                let route = mapViewModel.alternativeRoutes[index]
                
                RouteInfoCard(
                    route: route,
                    title: "Alternative route \(index + 1)",
                    isSelected: false,
                    showDetails: false
                ) {
                    selectAlternativeRoute(route)
                }
            }
        }
    }
    
    private var applyButton: some View {
        Button(action: {
            applyChanges()
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Apply settings")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .padding(.top, 20)
    }
    
    // MARK: - 功能方法
    
    private func applyChanges() {
        let needsRecalculation = selectedTransportType != mapViewModel.routeTransportType ||
                                avoidTolls != mapViewModel.avoidTolls ||
                                avoidHighways != mapViewModel.avoidHighways
        
        if needsRecalculation {
            // 更新设置
            mapViewModel.routeTransportType = selectedTransportType
            mapViewModel.avoidTolls = avoidTolls
            mapViewModel.avoidHighways = avoidHighways
            
            // 重新计算路线
            recalculateRoute()
        }
        
        dismiss()
    }
    
    private func recalculateRoute() {
        // 获取当前的起点和终点信息
        guard let destination = mapViewModel.selectedDestination else {
            print("No destination selected, cannot recalculate route")
            return
        }
        
        // 使用保存的起点信息，如果没有则使用当前位置
        if let origin = mapViewModel.selectedOrigin {
            // 有明确的起点，直接使用
            mapViewModel.calculateRouteWithOptions(from: origin, to: destination) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Route recalculation successful, transport type: \(self.selectedTransportType.localizedDescription)")
                    } else {
                        print("Route recalculation failed")
                    }
                }
            }
        } else if let mapView = mapViewModel.mapView,
                  let userLocation = mapView.userLocation.location {
            // 没有明确起点，使用当前位置
            let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            originItem.name = "My location"
            
            mapViewModel.calculateRouteWithOptions(from: originItem, to: destination) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Route recalculation successful, transport type: \(self.selectedTransportType.localizedDescription)")
                    } else {
                        print("Route recalculation failed")
                    }
                }
            }
        } else {
            // 都没有的话，使用原始方法
            mapViewModel.calculateRoute(to: destination)
        }
    }
    
    private func selectAlternativeRoute(_ route: MKRoute) {
        // 将备选路线设为当前路线
        if let currentIndex = mapViewModel.alternativeRoutes.firstIndex(of: route) {
            let oldCurrentRoute = mapViewModel.currentRoute
            mapViewModel.currentRoute = route
            mapViewModel.alternativeRoutes.remove(at: currentIndex)
            
            if let oldRoute = oldCurrentRoute {
                mapViewModel.alternativeRoutes.insert(oldRoute, at: 0)
            }
        }
    }
}

// MARK: - 子视图组件

struct TransportTypeRow: View {
    let type: MKDirectionsTransportType
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 40, height: 40)
                    .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PreferenceRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
        }
        .padding()
    }
}

struct RouteInfoCard: View {
    let route: MKRoute
    let title: String
    let isSelected: Bool
    let showDetails: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("Current")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Distance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formatDistance(route.distance))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formatTime(route.expectedTravelTime))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    if showDetails && !route.advisoryNotices.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Reminders")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(route.advisoryNotices.count) items")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                }
                
                if showDetails && !route.advisoryNotices.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(route.advisoryNotices.prefix(2), id: \.self) { notice in
                            Text("• \(notice)")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        
                        if route.advisoryNotices.count > 2 {
                            Text("There are \(route.advisoryNotices.count - 2) reminders...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f meters", distance)
        } else {
            return String(format: "%.1f kilometers", distance / 1000)
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours) hours \(minutes) minutes"
        } else {
            return "\(minutes) minutes"
        }
    }
}

struct RouteOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RouteOptionsView(mapViewModel: MapViewModel())
    }
}

// MARK: - 公交换乘步骤视图
struct TransitStepView: View {
    let step: MKRoute.Step
    let stepNumber: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 步骤编号
            Text("\(stepNumber)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(stepColor)
                .cornerRadius(10)
            
            // 简化的信息显示
            HStack(spacing: 8) {
                Image(systemName: getTransitIcon())
                    .font(.subheadline)
                    .foregroundColor(stepColor)
                
                Text(getSimplifiedInstruction())
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private var stepColor: Color {
        if step.instructions.contains("Walk") || step.instructions.contains("Walk") {
            return .orange
        } else if step.instructions.contains("Take") || step.instructions.contains("Take") || step.transportType == .transit {
            return .blue
        } else {
            return .gray
        }
    }
    
    private func getTransitIcon() -> String {
        let instruction = step.instructions.lowercased()
        
        if instruction.contains("Walk") || instruction.contains("Walk") {
            return "figure.walk"
        } else if instruction.contains("Subway") || instruction.contains("Track") {
            return "tram.fill"
        } else if instruction.contains("Bus") || instruction.contains("Bus") {
            return "bus.fill"
        } else if instruction.contains("Light rail") {
            return "train.side.front.car"
        } else if instruction.contains("Take") || instruction.contains("Take") {
            return "tram.fill"
        } else {
            return "location.fill"
        }
    }
    
    private func getSimplifiedInstruction() -> String {
        let instruction = step.instructions
        
        // 如果是步行
        if instruction.contains("Walk") || instruction.contains("Walk") {
            let minutes = Int(step.distance / 80) // 假设步行速度80米/分钟
            let walkTime = max(1, minutes) // 至少1分钟
            return "\(walkTime) minutes walk"
        }
        
        // 如果是公交/地铁
        if instruction.contains("Take") || instruction.contains("Take") {
            if let lineInfo = extractSimpleLineInfo() {
                return lineInfo
            } else if instruction.contains("Subway") {
                return "Subway"
            } else if instruction.contains("Bus") {
                return "Bus"
            } else {
                return "Public transport"
            }
        }
        
        // 默认显示简化的指令
        if instruction.isEmpty {
            return "Continue"
        } else {
            // 截取前10个字符，避免过长
            return String(instruction.prefix(10))
        }
    }
    
    private func extractSimpleLineInfo() -> String? {
        let instruction = step.instructions
        
        // 提取地铁线路（如"1号线"、"2号线"）
        if let lineRange = instruction.range(of: "line +\\d", options: .regularExpression) {
            return "Subway" + String(instruction[lineRange])
        }
        
        // 提取公交线路（如"101路"、"快速公交1号线"）
        if let busRange = instruction.range(of: "line +\\d", options: .regularExpression) {
            return String(instruction[busRange]) + "Bus"
        }
        
        // 提取其他数字+线的格式
        if let numberLineRange = instruction.range(of: "line +\\d", options: .regularExpression) {
            return String(instruction[numberLineRange])
        }
        
        return nil
    }
} 