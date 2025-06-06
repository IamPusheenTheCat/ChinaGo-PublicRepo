import SwiftUI
import MapKit
import CoreLocation

struct NearbySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var locationManager: LocationManager
    @State private var searchQuery = ""
    @State private var selectedCategory: SearchCategory = .parking
    @State private var showingParkingGuide = false
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false
    @State private var errorMessage: String?
    
    // 初始化方法需要添加locationManager参数
    init(mapViewModel: MapViewModel, locationManager: LocationManager) {
        self.mapViewModel = mapViewModel
        self.locationManager = locationManager
    }
    
    enum SearchCategory: String, CaseIterable {
        case parking = "Parking"
        case restaurant = "Restaurant"
        case hotel = "Hotel"
        case cafe = "Cafe"
        case shopping = "Shopping"
        
        var systemImage: String {
            switch self {
            case .parking: return "p.circle.fill"
            case .restaurant: return "fork.knife"
            case .hotel: return "bed.double.fill"
            case .cafe: return "cup.and.saucer.fill"
            case .shopping: return "bag.fill"
            }
        }
        
        var searchKeyword: String {
            switch self {
            case .parking: return "Parking"
            case .restaurant: return "Restaurant"
            case .hotel: return "Hotel"
            case .cafe: return "Cafe"
            case .shopping: return "Shopping"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search...", text: $searchQuery)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: searchQuery) { _ in
                            performSearch()
                        }
                }
                .padding()
                .background(Color(.systemGray6))
                
                // 分类选择
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SearchCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category,
                                action: {
                                    selectedCategory = category
                                    searchQuery = ""
                                    performSearch()
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                if selectedCategory == .parking {
                    // 停车指南链接
                    Button(action: {
                        showingParkingGuide = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                            Text("View parking guide")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .foregroundColor(.blue)
                    }
                    Divider()
                }
                
                if isSearching {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // 搜索结果列表
                    List(searchResults, id: \.self) { item in
                        NearbySearchResultRow(
                            item: item, 
                            userLocation: locationManager.location
                        ) {
                            // 停止当前导航（如果有的话）
                            if mapViewModel.isNavigating {
                                mapViewModel.stopNavigation()
                            }
                            
                            // 清除现有路线
                            mapViewModel.clearRoute()
                            
                            // 设置为新的目的地（覆盖旧目的地）
                            mapViewModel.selectDestination(
                                coordinate: item.placemark.coordinate, 
                                title: item.name ?? "Unknown location"
                            )
                            
                            // 自动计算路线并开始导航
                            let destinationItem = MKMapItem(placemark: item.placemark)
                            destinationItem.name = item.name ?? "Unknown location"
                            mapViewModel.calculateRouteAndStartNavigation(to: destinationItem)
                            
                            dismiss()
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Nearby search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingParkingGuide) {
                ParkingGuideView()
            }
        }
        .onAppear {
            performSearch()
        }
    }
    
    private func performSearch() {
        guard let userLocation = locationManager.location else {
            errorMessage = "Cannot get current location"
            return
        }
        
        let searchText = searchQuery.isEmpty ? selectedCategory.searchKeyword : searchQuery
        
        isSearching = true
        errorMessage = nil
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // 设置搜索范围（以用户位置为中心的2公里范围）
        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                isSearching = false
                
                if let error = error {
                    errorMessage = "Search failed: \(error.localizedDescription)"
                    searchResults = []
                    return
                }
                
                if let response = response {
                    searchResults = response.mapItems
                    if searchResults.isEmpty {
                        errorMessage = "No related locations found"
                    }
                } else {
                    searchResults = []
                    errorMessage = "No results found"
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: NearbySearchView.SearchCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category.systemImage)
                Text(category.rawValue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct NearbySearchResultRow: View {
    let item: MKMapItem
    let userLocation: CLLocation?
    let action: () -> Void
    
    @State private var isLoadingAddress = true
    @State private var fullAddress: String?
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name ?? "Unknown location")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if isLoadingAddress {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.6)
                            Text("Loading address...")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    } else if let address = fullAddress ?? item.placemark.formattedAddress {
                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    // 只有当地址加载完成后才显示距离
                    if !isLoadingAddress, let distance = calculateDistance() {
                        Text(formatDistance(distance))
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    } else if isLoadingAddress {
                        ProgressView()
                            .scaleEffect(0.6)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            loadDetailedAddress()
        }
    }
    
    private func loadDetailedAddress() {
        // 如果已经有格式化地址，快速完成加载
        if let existingAddress = item.placemark.formattedAddress, !existingAddress.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isLoadingAddress = false
            }
            return
        }
        
        // 使用反向地理编码获取详细地址
        let geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: item.placemark.coordinate.latitude,
            longitude: item.placemark.coordinate.longitude
        )
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                if let placemark = placemarks?.first {
                    var addressComponents = [String]()
                    
                    if let subLocality = placemark.subLocality {
                        addressComponents.append(subLocality)
                    }
                    if let thoroughfare = placemark.thoroughfare {
                        addressComponents.append(thoroughfare)
                    }
                    if let subThoroughfare = placemark.subThoroughfare {
                        addressComponents.append(subThoroughfare)
                    }
                    if let locality = placemark.locality {
                        addressComponents.append(locality)
                    }
                    
                    self.fullAddress = addressComponents.isEmpty ? "Address information not available" : addressComponents.joined(separator: ", ")
                } else {
                    self.fullAddress = "Address loading failed"
                }
                
                // 添加一个最小延迟，确保用户能看到加载过程
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isLoadingAddress = false
                }
            }
        }
    }
    
    private func calculateDistance() -> CLLocationDistance? {
        guard let userLocation = userLocation else {
            return nil
        }
        
        let itemLocation = CLLocation(
            latitude: item.placemark.coordinate.latitude,
            longitude: item.placemark.coordinate.longitude
        )
        
        return userLocation.distance(from: itemLocation)
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f meters", distance)
        } else {
            return String(format: "%.1f kilometers", distance / 1000)
        }
    }
}

extension MKPlacemark {
    var formattedAddress: String? {
        var components = [String]()
        
        if let subLocality = subLocality {
            components.append(subLocality)
        }
        if let thoroughfare = thoroughfare {
            components.append(thoroughfare)
        }
        if let subThoroughfare = subThoroughfare {
            components.append(subThoroughfare)
        }
        
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
} 