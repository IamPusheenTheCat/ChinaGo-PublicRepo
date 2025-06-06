//
//  RoutePickerView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct RoutePickerView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var startLocationText = ""
    @State private var endLocationText = ""
    @State private var selectedTransportType: MKDirectionsTransportType = .automobile
    @State private var isSearchingStart = false
    @State private var isSearchingEnd = false
    @State private var startSearchResults: [MKMapItem] = []
    @State private var endSearchResults: [MKMapItem] = []
    @State private var selectedStartLocation: MKMapItem?
    @State private var selectedEndLocation: MKMapItem?
    @State private var isCalculatingRoute = false
    @State private var showingRouteResults = false
    @State private var avoidTolls = false
    @State private var avoidHighways = false
    @State private var showingStartResults = false
    @State private var showingEndResults = false
    
    // Quick start options
    private let quickStartOptions = [
        ("My Location", "location.fill", "current"),
        ("Home", "house.fill", "home"),
        ("Work", "building.2.fill", "work")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Route input card
                    routeInputCard
                    
                    // Transport mode selection
                    transportModeSelector
                    
                    // Route preferences
                    routePreferencesCard
                    
                    // Route planning button
                    planRouteButton
                    
                    // Route results display
                    if showingRouteResults {
                        routeResultsCard
                    }
                }
                .padding()
            }
            .navigationTitle("Route Planning")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isCalculatingRoute {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .onAppear {
            setupCurrentLocation()
        }
    }
    
    // MARK: - Route input card
    private var routeInputCard: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "route.fill")
                    .foregroundColor(.blue)
                Text("Set Route")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Start")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    
                    TextField("Enter start location", text: $startLocationText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            searchStartLocation()
                        }
                        .onChange(of: startLocationText) { _ in
                            if startLocationText.count > 2 {
                                searchStartLocation()
                            }
                        }
                    
                    if !startLocationText.isEmpty {
                        Button(action: {
                            startLocationText = ""
                            startSearchResults = []
                            selectedStartLocation = nil
                            showingStartResults = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                
                // Quick start options
                HStack(spacing: 10) {
                    ForEach(quickStartOptions, id: \.2) { option in
                        Button(action: {
                            selectQuickStartOption(option.2)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: option.1)
                                    .font(.caption2)
                                Text(option.0)
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                }
                
                // Start search results
                if !startSearchResults.isEmpty && showingStartResults {
                    searchResultsList(results: startSearchResults, isForStart: true)
                }
            }
            
            // Swap button
            HStack {
                Spacer()
                Button(action: swapLocations) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Destination")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    TextField("Enter destination", text: $endLocationText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            searchEndLocation()
                        }
                        .onChange(of: endLocationText) { _ in
                            if endLocationText.count > 2 {
                                searchEndLocation()
                            }
                        }
                    
                    if !endLocationText.isEmpty {
                        Button(action: {
                            endLocationText = ""
                            endSearchResults = []
                            selectedEndLocation = nil
                            showingEndResults = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                
                // End search results
                if !endSearchResults.isEmpty && showingEndResults {
                    searchResultsList(results: endSearchResults, isForStart: false)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Transport mode selection
    private var transportModeSelector: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "car.2.fill")
                    .foregroundColor(.blue)
                Text("Transport Mode")
                    .font(.headline)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                TransportModeButton(
                    icon: "car.fill",
                    title: "Drive",
                    subtitle: "Fast Direct",
                    transportType: .automobile,
                    selectedType: $selectedTransportType
                )
                
                TransportModeButton(
                    icon: "figure.walk",
                    title: "Walk",
                    subtitle: "Healthy & Green",
                    transportType: .walking,
                    selectedType: $selectedTransportType
                )
                
                TransportModeButton(
                    icon: "bicycle",
                    title: "Bike",
                    subtitle: "Flexible",
                    transportType: .automobile,
                    selectedType: $selectedTransportType
                )
                
                TransportModeButton(
                    icon: "tram.fill",
                    title: "Transit",
                    subtitle: "Economical",
                    transportType: .transit,
                    selectedType: $selectedTransportType
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 路线偏好设置
    private var routePreferencesCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.blue)
                Text("Route Preferences")
                    .font(.headline)
                Spacer()
            }
            
            if selectedTransportType == .automobile {
                VStack(spacing: 12) {
                    HStack {
                        Toggle("Avoid Toll Roads", isOn: $avoidTolls)
                        Spacer()
                    }
                    
                    HStack {
                        Toggle("Avoid Highways", isOn: $avoidHighways)
                        Spacer()
                    }
                }
            }
            
            // 实时路况信息
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Real-time Traffic")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Current Traffic: \(mapViewModel.trafficCondition)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Circle()
                    .fill(trafficStatusColor)
                    .frame(width: 12, height: 12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 路线规划按钮
    private var planRouteButton: some View {
        Button(action: calculateRoute) {
            HStack {
                if isCalculatingRoute {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "map.fill")
                }
                
                Text(isCalculatingRoute ? "Calculating..." : "Start Route Planning")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(canPlanRoute ? Color.blue : Color.gray)
            .cornerRadius(12)
        }
        .disabled(!canPlanRoute || isCalculatingRoute)
    }
    
    // MARK: - 路线结果卡片
    private var routeResultsCard: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "map.circle.fill")
                    .foregroundColor(.green)
                Text("Route Options")
                    .font(.headline)
                Spacer()
                
                Button("Start Navigation") {
                    startNavigation()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green)
                .cornerRadius(20)
            }
            
            if let route = mapViewModel.currentRoute {
                VStack(spacing: 12) {
                    // 主要路线信息
                    HStack {
                        RouteInfoItem(
                            icon: "clock.fill",
                            title: "Estimated Time",
                            value: formatDuration(route.expectedTravelTime),
                            color: .blue
                        )
                        
                        Spacer()
                        
                        RouteInfoItem(
                            icon: "map.fill",
                            title: "Total Distance",
                            value: formatDistance(route.distance),
                            color: .green
                        )
                        
                        Spacer()
                        
                        RouteInfoItem(
                            icon: "gauge.high",
                            title: "Traffic",
                            value: mapViewModel.trafficCondition,
                            color: trafficStatusColor
                        )
                    }
                    
                    // 备选路线
                    if !mapViewModel.alternativeRoutes.isEmpty {
                        Divider()
                        
                        Text("Alternative Routes")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(Array(mapViewModel.alternativeRoutes.enumerated()), id: \.offset) { index, altRoute in
                            AlternativeRouteRow(
                                routeNumber: index + 2,
                                route: altRoute,
                                onSelect: {
                                    selectAlternativeRoute(altRoute)
                                }
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 辅助视图
    private func searchResultsList(results: [MKMapItem], isForStart: Bool) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(results.prefix(5).enumerated()), id: \.offset) { index, item in
                Button(action: {
                    if isForStart {
                        selectStartLocation(item)
                    } else {
                        selectEndLocation(item)
                    }
                }) {
                    HStack {
                        Image(systemName: "location.circle")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name ?? "Unknown Location")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            if let address = item.placemark.title {
                                Text(address)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < results.count - 1 {
                    Divider()
                        .padding(.leading, 40)
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.top, 4)
    }
    
    // MARK: - 计算属性
    private var canPlanRoute: Bool {
        selectedStartLocation != nil && selectedEndLocation != nil
    }
    
    private var trafficStatusColor: Color {
        switch mapViewModel.trafficCondition {
        case "Smooth":
            return .green
        case "Slow":
            return .orange
        case "Congested":
            return .red
        default:
            return .blue
        }
    }
    
    // MARK: - 功能方法
    private func setupCurrentLocation() {
        if let location = locationManager.location {
            startLocationText = "My Location"
            
            // 创建当前位置的MKMapItem
            let placemark = MKPlacemark(coordinate: location.coordinate)
            selectedStartLocation = MKMapItem(placemark: placemark)
            selectedStartLocation?.name = "My Location"
        }
    }
    
    private func selectQuickStartOption(_ option: String) {
        switch option {
        case "current":
            if let location = locationManager.location {
                startLocationText = "My Location"
                let placemark = MKPlacemark(coordinate: location.coordinate)
                selectedStartLocation = MKMapItem(placemark: placemark)
                selectedStartLocation?.name = "My Location"
            }
        case "home":
            startLocationText = "Home"
            // 这里可以从用户设置中获取家的地址
        case "work":
            startLocationText = "Work"
            // 这里可以从用户设置中获取公司地址
        default:
            break
        }
    }
    
    private func swapLocations() {
        // 交换文本
        let tempText = startLocationText
        startLocationText = endLocationText
        endLocationText = tempText
        
        // 交换选中的位置
        let tempLocation = selectedStartLocation
        selectedStartLocation = selectedEndLocation
        selectedEndLocation = tempLocation
    }
    
    private func searchStartLocation() {
        guard !startLocationText.isEmpty else { 
            startSearchResults = []
            showingStartResults = false
            return 
        }
        isSearchingStart = true
        showingStartResults = true
        
        searchLocation(startLocationText) { results in
            DispatchQueue.main.async {
                self.startSearchResults = results
                self.isSearchingStart = false
                // 保持 showingStartResults = true，这样结果会继续显示
            }
        }
    }
    
    private func searchEndLocation() {
        guard !endLocationText.isEmpty else { 
            endSearchResults = []
            showingEndResults = false
            return 
        }
        isSearchingEnd = true
        showingEndResults = true
        
        searchLocation(endLocationText) { results in
            DispatchQueue.main.async {
                self.endSearchResults = results
                self.isSearchingEnd = false
                // 保持 showingEndResults = true，这样结果会继续显示
            }
        }
    }
    
    private func searchLocation(_ query: String, completion: @escaping ([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                completion(response.mapItems)
            } else {
                completion([])
            }
        }
    }
    
    private func selectStartLocation(_ item: MKMapItem) {
        selectedStartLocation = item
        startLocationText = item.name ?? "Unknown Location"
        startSearchResults = []
        isSearchingStart = false
        showingStartResults = false
    }
    
    private func selectEndLocation(_ item: MKMapItem) {
        selectedEndLocation = item
        endLocationText = item.name ?? "Unknown Location"
        endSearchResults = []
        isSearchingEnd = false
        showingEndResults = false
    }
    
    private func calculateRoute() {
        guard let startLocation = selectedStartLocation,
              let endLocation = selectedEndLocation else { return }
        
        isCalculatingRoute = true
        mapViewModel.routeTransportType = selectedTransportType
        
        // 设置路线偏好
        mapViewModel.avoidTolls = avoidTolls
        mapViewModel.avoidHighways = avoidHighways
        
        mapViewModel.calculateRouteWithOptions(from: startLocation, to: endLocation) { success in
            DispatchQueue.main.async {
                self.isCalculatingRoute = false
                self.showingRouteResults = success
                
                if success {
                    // 路线计算成功，可以在这里添加成功提示
                } else {
                    // 路线计算失败，显示错误信息
                }
            }
        }
    }
    
    private func selectAlternativeRoute(_ route: MKRoute) {
        mapViewModel.selectAlternativeRoute(route)
    }
    
    private func startNavigation() {
        mapViewModel.startNavigation()
        dismiss()
    }
    
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours) hours \(minutes) minutes"
        } else {
            return "\(minutes) minutes"
        }
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f meters", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
}

// MARK: - 辅助视图组件

struct TransportModeButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let transportType: MKDirectionsTransportType
    @Binding var selectedType: MKDirectionsTransportType
    
    var body: some View {
        Button(action: {
            selectedType = transportType
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var isSelected: Bool {
        selectedType == transportType
    }
}

struct RouteInfoItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

struct AlternativeRouteRow: View {
    let routeNumber: Int
    let route: MKRoute
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text("Route \(routeNumber)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(formatDuration(route.expectedTravelTime))
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Text("·")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(formatDistance(route.distance))
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h\(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0fm", distance)
        } else {
            return String(format: "%.1fkm", distance / 1000)
        }
    }
}

struct RoutePickerView_Previews: PreviewProvider {
    static var previews: some View {
        RoutePickerView(
            mapViewModel: MapViewModel(),
            locationManager: LocationManager()
        )
    }
} 