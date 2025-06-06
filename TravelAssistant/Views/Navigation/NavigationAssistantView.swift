//
//  NavigationAssistantView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct NavigationAssistantView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var favoriteRoutesManager = FavoriteRoutesManager()
    @StateObject private var motionManager = MotionManager.shared
    @State private var showingDestinationPicker = false
    @State private var showingDirections = false
    @State private var selectedMapType: MKMapType = .standard
    @State private var searchText = ""
    @State private var showingRouteOptions = false
    @State private var showingLocationPermissionAlert = false
    @State private var hasRequestedInitialLocation = false
    @State private var showingRoutePicker = false
    @State private var showingSearchResults = false
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false
    @State private var showingRoutePlanning = false
    @State private var currentDestinationName = ""
    @State private var currentOriginName = "My location"
    @State private var isEditingOrigin = false
    @State private var isEditingDestination = false
    @State private var originSearchText = ""
    @State private var destinationSearchText = ""
    @State private var originSearchResults: [MKMapItem] = []
    @State private var destinationSearchResults: [MKMapItem] = []
    @State private var showingOriginResults = false
    @State private var showingDestinationResults = false
    @State private var selectedOrigin: MKMapItem?
    @State private var selectedDestination: MKMapItem?
    @State private var showingDestinationGuide = false
    @State private var showingParkingGuide = false
    @State private var showingFavorites = false
    @State private var showingFavoriteRoutes = false
    @State private var showingAddToFavorites = false
    @State private var showingAddToFavoriteRoutes = false
    @State private var favoriteCategory = "Other"
    @State private var favoriteRouteName = ""
    @State private var previousOrigin: MKMapItem?
    @State private var previousDestination: MKMapItem?
    @State private var showingMapTypeSheet = false
    @State private var showingNearbySearch = false
    @State private var showingHistoryLocation = false
    
    // 添加环境值来获取焦点状态
    @FocusState private var isSearchFocused: Bool
    @FocusState private var isOriginFocused: Bool
    @FocusState private var isDestinationFocused: Bool
    
    // 新增方向跟踪状态
    @State private var isMotionTrackingEnabled = false
    @State private var showingMotionDetails = false
    
    // 搜索防抖相关变量
    @State private var searchDebounceTimer: Timer?
    @State private var isTyping = false
    
    // 计算属性：是否可以规划路线
    private var canPlanRoute: Bool {
        return hasValidOrigin && hasValidDestination && !isEditingOrigin && !isEditingDestination
    }
    
    // 计算属性：是否有有效的起点
    private var hasValidOrigin: Bool {
        return selectedOrigin != nil || (currentOriginName == "My location" && locationManager.location != nil)
    }
    
    // 计算属性：是否有有效的终点
    private var hasValidDestination: Bool {
        return selectedDestination != nil || !currentDestinationName.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // 主地图视图
                MapView(
                    locationManager: locationManager,
                    mapViewModel: mapViewModel,
                    favoritesManager: favoritesManager,
                    selectedMapType: selectedMapType
                )
                .ignoresSafeArea(.all, edges: .bottom)
                .overlay(
                    // 浮动的地图类型切换按钮（右上角）
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedMapType = selectedMapType == .standard ? .satellite : .standard
                                }
                            }) {
                                Image(systemName: selectedMapType == .standard ? "map.fill" : "globe.americas.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            .padding(.trailing, 16)
                            .padding(.top, mapViewModel.isNavigating ? 60 : 120) // 根据导航状态调整位置
                        }
                        Spacer()
                    },
                    alignment: .topTrailing
                )
                .overlay(
                    // 导航模式下的路线对齐按钮（左下角）
                    Group {
                        if mapViewModel.isNavigating && mapViewModel.hasRoute {
                            VStack {
                                Spacer()
                                HStack {
                                    Button(action: {
                                        mapViewModel.alignCameraWithRoute()
                                    }) {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.mint.opacity(0.8)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .clipShape(Circle())
                                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    }
                                    .padding(.leading, 16)
                                    .padding(.bottom, 100) // 避开底部控件
                                    Spacer()
                                }
                            }
                        }
                    },
                    alignment: .bottomLeading
                )
                
                // 位置权限被拒绝的覆盖层
                if locationManager.locationStatus == .denied || locationManager.locationStatus == .restricted {
                    locationPermissionDeniedOverlay
                }
                
                // 顶部搜索和控制栏
                VStack(spacing: 0) {
                    topControlsView
                    
                    // 路线规划小栏目 - 只在非导航模式下显示
                    if showingRoutePlanning && !mapViewModel.isNavigating {
                        routePlanningBar
                            .onAppear {
                                print("🚏 Route planning bar is displayed")
                            }
                    } else {
                        // 添加调试信息
                        Text("")
                            .onAppear {
                                print("🚏 Route planning bar is not displayed - showingRoutePlanning: \(showingRoutePlanning), mapViewModel.isNavigating: \(mapViewModel.isNavigating)")
                            }
                            .opacity(0)
                    }
                    
                    // 路线信息卡片 - 始终显示（如果有路线）
                    if mapViewModel.hasRoute {
                        routeInfoCard
                    }
                    Spacer()
                    
                    // 底部控制按钮 - 只在非导航模式下显示
                    if !mapViewModel.isNavigating {
                        bottomControlsView
                    }
                }
            }
            .navigationBarHidden(true)
            .dismissKeyboardOnTap() // 使用全局键盘管理器
            .onAppear {
                print("NavigationAssistantView appeared")
                
                // 主动请求位置权限，不管当前状态如何
                print("Proactively requesting location permission...")
                locationManager.requestLocationPermission()
                
                // 延迟一秒后再次检查并强制更新（给权限对话框时间显示）
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("Delayed check - Current status: \(locationManager.locationStatus?.rawValue ?? -1)")
                    locationManager.forceLocationUpdate()
                }
                
                // 添加通知观察者
                NotificationCenter.default.addObserver(
                    forName: Notification.Name("AddToFavorites"),
                    object: nil,
                    queue: .main
                ) { [self] notification in
                    if let location = notification.userInfo?["location"] as? MKMapItem {
                        selectedDestination = location
                        showingAddToFavorites = true
                    }
                }
                
                NotificationCenter.default.addObserver(
                    forName: Notification.Name("StartNavigation"),
                    object: nil,
                    queue: .main
                ) { [self] notification in
                    if let coordinate = notification.userInfo?["coordinate"] as? CLLocationCoordinate2D,
                       let title = notification.userInfo?["title"] as? String {
                        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                        destination.name = title
                        startNavigationToDestination(destination)
                    }
                }
                
                // 监听从精确导航传来的地址导航请求
                NotificationCenter.default.addObserver(
                    forName: Notification.Name("StartNavigationWithAddresses"),
                    object: nil,
                    queue: .main
                ) { [self] notification in
                    print("📡 收到 StartNavigationWithAddresses 通知")
                    if let addresses = notification.object as? [String: Any],
                       let endLocation = addresses["end"] as? String {
                        print("🎯 提取终点地址: \(endLocation)")
                        // 搜索终点地址并开始导航
                        searchAndNavigateToAddress(endLocation)
                    } else {
                        print("❌ StartNavigationWithAddresses 通知数据格式错误")
                        print("❌ 收到的数据: \(notification.object ?? "nil")")
                    }
                }
                
                // 监听从精确导航传来的详细导航请求（新增）
                NotificationCenter.default.addObserver(
                    forName: Notification.Name("StartNavigationWithDetails"),
                    object: nil,
                    queue: .main
                ) { [self] notification in
                    if let details = notification.object as? [String: Any],
                       let destination = details["destination"] as? MKMapItem,
                       let destinationName = details["destinationName"] as? String,
                       let startLocationName = details["startLocationName"] as? String,
                       let useCurrentLocation = details["useCurrentLocation"] as? Bool {
                        
                        print("🚗 收到详细导航请求 - 起点: \(startLocationName), 终点: \(destinationName)")
                        
                        // 清除之前的路线和状态
                        mapViewModel.clearRoute()
                        
                        // 显示路线规划栏
                        withAnimation {
                            showingRoutePlanning = true
                        }
                        currentDestinationName = destinationName
                        currentOriginName = startLocationName
                        
                        // 设置选中的地点
                        selectedDestination = destination
                        mapViewModel.selectedDestination = destination
                        
                        if !useCurrentLocation {
                            // 如果不使用当前位置，搜索起点
                            searchAndSetOrigin(startLocationName) {
                                // 起点设置完成后开始导航
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.startNavigationToDestination(destination)
                                }
                            }
                        } else {
                            // 使用当前位置作为起点
                            if let userLocation = locationManager.location {
                                let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
                                originItem.name = "My location"
                                selectedOrigin = originItem
                                mapViewModel.selectedOrigin = originItem
                            }
                            
                            // 延迟一点开始导航，确保UI更新完成
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                // 开始导航到目标地点
                                self.startNavigationToDestination(destination)
                            }
                        }
                    }
                }
            }
            .onDisappear {
                // 移除通知观察者
                NotificationCenter.default.removeObserver(self)
                
                // 清理防抖定时器
                searchDebounceTimer?.invalidate()
            }
            .onChange(of: locationManager.location) { newLocation in
                if let location = newLocation {
                    if !hasRequestedInitialLocation {
                        hasRequestedInitialLocation = true
                        print("Got user location, centering map on city level")
                        mapViewModel.centerOnCityLevel(location)
                        
                        // 自动启用朝向跟踪，显示扇形指示器
                        if !mapViewModel.followDeviceHeading {
                            print("🧭 Auto-enabling heading tracking for compass display")
                            let motionManager = MotionManager.shared
                            if !motionManager.isMotionActive {
                                motionManager.startMotionUpdates()
                                motionManager.startHeadingUpdates()
                            }
                            mapViewModel.enableDeviceHeadingTracking(motionManager)
                        }
                    }
                }
            }
            .onChange(of: locationManager.locationStatus) { newStatus in
                print("Location status changed to: \(newStatus?.rawValue ?? -1)")
                switch newStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    if locationManager.location == nil {
                        print("Permission granted but no location yet, waiting...")
                    }
                case .denied, .restricted:
                    print("Permission denied, showing alert")
                    showingLocationPermissionAlert = true
                case .notDetermined:
                    print("Permission not determined yet")
                default:
                    break
                }
            }
            .alert("Location Permission Required", isPresented: $showingLocationPermissionAlert) {
                Button("Settings") {
                    openLocationSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("To provide accurate navigation services, please enable location permission in Settings.")
            }
            .sheet(isPresented: $showingDestinationPicker) {
                DestinationPickerView(mapViewModel: mapViewModel)
            }
            .sheet(isPresented: $showingRouteOptions) {
                RouteOptionsView(mapViewModel: mapViewModel)
            }
            .sheet(isPresented: $showingRoutePicker) {
                RoutePickerView(mapViewModel: mapViewModel, locationManager: locationManager)
            }
            .sheet(isPresented: $showingDestinationGuide) {
                DestinationSelectionGuideView()
            }
            .sheet(isPresented: $showingParkingGuide) {
                ParkingGuideView()
            }
            .sheet(isPresented: $showingFavorites) {
                FavoritesListView(
                    favoritesManager: favoritesManager,
                    mapViewModel: mapViewModel
                ) { location in
                    selectDestination(location)
                }
            }
            .sheet(isPresented: $showingFavoriteRoutes) {
                addToFavoriteRoutesView
            }
            .sheet(isPresented: $showingAddToFavoriteRoutes) {
                addToFavoriteRoutesView
            }
            .sheet(isPresented: $showingAddToFavorites) {
                addToFavoritesView
            }
            .sheet(isPresented: $showingNearbySearch) {
                NearbySearchView(mapViewModel: mapViewModel, locationManager: locationManager)
            }
            .sheet(isPresented: $showingHistoryLocation) {
                HistoryLocationView(
                    historyManager: mapViewModel.historyLocationManager,
                    mapViewModel: mapViewModel,
                    locationManager: locationManager
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // 位置权限被拒绝的覆盖层
    private var locationPermissionDeniedOverlay: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 15) {
                Image(systemName: "location.slash.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Cannot get location information")
                        .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Please enable location permission in settings to use navigation")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Button("Go to settings") {
                    openLocationSettings()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(25)
            }
            .padding(30)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(Color.black.opacity(0.3))
    }
    
    // 顶部控制视图
    private var topControlsView: some View {
        VStack(spacing: 8) { // 减小垂直间距
            // 只在非导航模式下显示搜索栏和功能按钮
            if !mapViewModel.isNavigating {
                // 搜索栏和地图类型切换
                HStack(spacing: 12) {
                    // 搜索栏
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 14)) // 减小图标大小
                        
                        TextField("Search location or address", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 14)) // 减小字体大小
                            .focused($isSearchFocused)
                            .submitLabel(.search)
                            .onSubmit {
                                handleSearchSubmit()
                                isSearchFocused = false
                            }
                            .onChange(of: searchText) { _, newValue in
                                // 取消之前的搜索定时器
                                searchDebounceTimer?.invalidate()
                                
                                if newValue.isEmpty {
                                    // 立即清除结果
                                    searchResults = []
                                    showingSearchResults = false
                                    showingRoutePlanning = false
                                    isTyping = false
                                } else {
                                    // 标记正在输入
                                    isTyping = true
                                    
                                    // 设置防抖定时器，0.6秒后搜索
                                    searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                                        DispatchQueue.main.async {
                                            if newValue.count >= 2 && !newValue.isEmpty {
                                                self.isTyping = false
                                                self.searchLocation()
                                            }
                                        }
                                    }
                                }
                            }
                        
                        if isSearching {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else if isTyping {
                            // 输入中状态
                            Image(systemName: "keyboard")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        } else if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                searchResults = []
                                showingSearchResults = false
                                showingRoutePlanning = false
                                currentDestinationName = ""
                                // 取消防抖定时器
                                searchDebounceTimer?.invalidate()
                                isTyping = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // 收藏夹按钮菜单
                    Menu {
                        Button(action: {
                            showingFavorites = true
                        }) {
                            Label("Location favorites", systemImage: "mappin.circle")
                        }
                        
                        Button(action: {
                            showingFavoriteRoutes = true
                        }) {
                            Label("Route favorites", systemImage: "arrow.triangle.turn.up.right.diamond")
                        }
                    } label: {
                        Image(systemName: showingFavorites ? "star.fill" : "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                
                // 搜索结果列表 - 移到这里
                if showingSearchResults && !searchResults.isEmpty {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(searchResults.prefix(5), id: \.self) { item in
                                Button(action: {
                                    selectDestinationAndStartNavigation(item)
                                }) {
                                    HStack {
                                        Image(systemName: "location.circle")
                                            .foregroundColor(.blue)
                                            .font(.system(size: 14))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name ?? "Unknown location")
                                                .font(.system(size: 14))
                                                .foregroundColor(.primary)
                                            
                                            Text(formatAddress(item.placemark))
                                                .font(.system(size: 12))
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if item != searchResults.prefix(5).last {
                                    Divider()
                                        .padding(.leading, 40)
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                    .frame(maxHeight: 200)
                    .padding(.horizontal, 12)
                    .zIndex(10)  // 提高搜索结果的zIndex
                }
                
                // 四个功能按钮
                HStack(spacing: 8) { // 减小按钮之间的间距
                    // 目的地选择按钮
                    Button(action: {
                        // 禁用陀螺仪
                        mapViewModel.disableDeviceHeadingTracking()
                        showingDestinationGuide = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 16))
                            Text("Destination")
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    // 路线规划按钮
                    Button(action: {
                        print("🚏 Route planning button was clicked")
                        print("🚏 Current state - showingRoutePlanning: \(showingRoutePlanning), mapViewModel.isNavigating: \(mapViewModel.isNavigating)")
                        // 禁用陀螺仪
                        mapViewModel.disableDeviceHeadingTracking()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.25)) {
                            showingRoutePlanning = true
                        }
                        print("🚏 After setting - showingRoutePlanning: \(showingRoutePlanning)")
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                .font(.system(size: 16))
                            Text("Route")
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.pink.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)  // 添加明确的按钮样式
                    .contentShape(Rectangle())  // 确保整个区域都可以点击
                    
                    // 周边搜索按钮（替换原来的停车按钮）
                    Button(action: {
                        showingNearbySearch = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "magnifyingglass.circle")
                                .font(.system(size: 16))
                            Text("Nearby")
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange.opacity(0.7), Color.yellow.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    // 历史地点按钮
                    Button(action: {
                        showingHistoryLocation = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 16))
                            Text("History")
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.indigo.opacity(0.7), Color.purple.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    // 路线选项按钮
                    Button(action: {
                        showingRouteOptions = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 16))
                            Text("Options")
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.7), Color.mint.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            } else {
                // 导航模式下显示退出导航按钮和视角切换按钮
                HStack {
                    Button(action: {
                        mapViewModel.stopNavigation()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                            Text("Exit navigation")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    // 第一人称/第三人称切换按钮
                    Button(action: {
                        mapViewModel.toggleFirstPersonView()
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: mapViewModel.isFirstPersonView ? "eye.fill" : "eye")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            Text(mapViewModel.isFirstPersonView ? "Third person" : "First person")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                        .frame(width: 70, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
        }
        .background(.ultraThinMaterial)
    }
    
    // 路线规划小栏目
    private var routePlanningBar: some View {
        VStack(spacing: 8) {
            HStack {
                // 起点 - 可点击编辑
                Button(action: {
                    isEditingOrigin = true
                    isEditingDestination = false
                    originSearchText = currentOriginName == "My location" ? "" : currentOriginName
                    showingOriginResults = false
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text(currentOriginName)
                        .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // 箭头
                Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                    .font(.caption)
                
                // 终点 - 可点击编辑
                Button(action: {
                    isEditingDestination = true
                    isEditingOrigin = false
                    destinationSearchText = currentDestinationName.isEmpty ? searchText : currentDestinationName
                    showingDestinationResults = false
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    
                        Text(currentDestinationName.isEmpty ? searchText : currentDestinationName)
                        .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // 取消按钮
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.25)) {
                        showingRoutePlanning = false
                    }
                    // 延迟重置其他状态，让动画更流畅
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentDestinationName = ""
                        currentOriginName = "My location"
                        searchText = ""
                        isEditingOrigin = false
                        isEditingDestination = false
                    }
                    mapViewModel.stopNavigation()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
            
            // 编辑起点输入框
            if isEditingOrigin {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        TextField("Enter starting location", text: $originSearchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.subheadline)
                            .focused($isOriginFocused)
                            .submitLabel(.search)
                            .onSubmit {
                                if !originSearchText.isEmpty {
                                    searchOriginLocation()
                                }
                                isOriginFocused = false
                            }
                            .onChange(of: originSearchText) { _, newValue in
                                if newValue.isEmpty {
                                    originSearchResults = []
                                    showingOriginResults = false
                                } else if newValue.count > 1 {
                                    searchOriginLocation()
                                }
                            }
                        
                        Button("Cancel") {
                            isEditingOrigin = false
                            originSearchText = ""
                            showingOriginResults = false
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    
                    // 起点搜索结果
                    if showingOriginResults && !originSearchResults.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(Array(originSearchResults.prefix(3).enumerated()), id: \.offset) { index, item in
                        Button(action: {
                                    selectOrigin(item)
                                }) {
                                    HStack {
                                        Image(systemName: "location.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.caption)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name ?? "Unknown location")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                            
                                            Text(formatAddress(item.placemark))
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if index < originSearchResults.count - 1 {
                                    Divider()
                                        .padding(.leading, 36)
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                }
            }
            
            // 编辑终点输入框
            if isEditingDestination {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        TextField("Enter destination location", text: $destinationSearchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.subheadline)
                            .focused($isDestinationFocused)
                            .submitLabel(.search)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("完成") {
                                        isDestinationFocused = false
                                    }
                                }
                            }
                            .onSubmit {
                                if !destinationSearchText.isEmpty {
                                    searchDestinationLocation()
                                }
                                isDestinationFocused = false
                            }
                        
                        Button("Cancel") {
                            isEditingDestination = false
                            destinationSearchText = ""
                            showingDestinationResults = false
                        }
                        .font(.caption)
                                .foregroundColor(.blue)
                        }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                        
                    // 终点搜索结果
                    if showingDestinationResults && !destinationSearchResults.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(Array(destinationSearchResults.prefix(3).enumerated()), id: \.offset) { index, item in
                        Button(action: {
                                    selectDestination(item)
                                }) {
                                    HStack {
                                        Image(systemName: "location.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name ?? "Unknown location")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                            
                                            Text(formatAddress(item.placemark))
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if index < destinationSearchResults.count - 1 {
                                    Divider()
                                        .padding(.leading, 36)
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                }
            }
            
            // 导航状态和控制按钮 - 总是显示这一行
            HStack {
                // 状态提示
                if mapViewModel.isRouteCalculating {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Planning route...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else if mapViewModel.hasRoute {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text("Route planning completed")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                } else {
                    // 如果没有路线且不在计算中，显示等待状态
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text("Waiting for route calculation...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // 右侧按钮区域
                if mapViewModel.hasRoute {
                    // 已有路线时显示导航控制按钮
                    if mapViewModel.isNavigating {
                        Button(action: {
                            mapViewModel.stopNavigation()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "stop.fill")
                                    .font(.caption)
                                Text("Stop navigation")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                    } else {
                        Button(action: {
                            // 重新启用陀螺仪
                            let motionManager = MotionManager.shared
                            if !motionManager.isMotionActive {
                                motionManager.startMotionUpdates()
                                motionManager.startHeadingUpdates()
                            }
                            mapViewModel.enableDeviceHeadingTracking(motionManager)
                            mapViewModel.startNavigation()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "location.north.fill")
                                    .font(.caption)
                                Text("Start navigation")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                } else if canPlanRoute {
                    // 当起点和终点都选择好了，显示规划路线按钮
                    Button(action: {
                        calculateRouteFromOriginToDestination()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "map")
                                .font(.caption)
                            Text("Plan route")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                } else {
                    // 没有路线时显示占位按钮
                    HStack(spacing: 6) {
                        Image(systemName: "location.north")
                            .font(.caption)
                        Text(hasValidDestination ? "Plan route" : "Select destination")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
            }
                }
                .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        // 移除错误的opacity条件，路线规划栏应该在showingRoutePlanning为true时就显示
        .animation(.easeInOut(duration: 0.25), value: showingRoutePlanning)
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .move(edge: .bottom)),
            removal: .opacity.combined(with: .move(edge: .bottom))
        ))
            }
            
    // 路线信息卡片
    private var routeInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(mapViewModel.isNavigating ? "Navigating" : "Route Information")
                    .font(.headline)
                Spacer()
                
                // 只在非导航模式下显示交通状况和选项按钮
                if !mapViewModel.isNavigating {
                    // 交通状况指示器
                    HStack(spacing: 4) {
                        Circle()
                            .fill(trafficColor)
                            .frame(width: 8, height: 8)
                        Text(mapViewModel.trafficCondition)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Options") {
                        showingRouteOptions = true
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                
                // 在导航模式下只显示关闭按钮
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        mapViewModel.clearRoute()
                        showingRoutePlanning = false
                    }
                    // 延迟重置其他状态，让动画更流畅
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        currentDestinationName = ""
                        currentOriginName = "My location"
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
            
            if let route = mapViewModel.currentRoute {
                VStack(spacing: 8) {
                    // 主要信息行
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Distance")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatDistance(mapViewModel.remainingDistance ?? route.distance))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatTime(mapViewModel.remainingTime ?? route.expectedTravelTime))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        if let eta = mapViewModel.estimatedTimeOfArrival {
                            VStack(alignment: .leading) {
                                Text("Estimated arrival")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(formatETA(eta))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // 只在非导航模式下显示公交换乘信息
                    if mapViewModel.routeTransportType == .transit && !mapViewModel.isNavigating {
                        transitInfoSection(route)
                    }
                    
                    // 导航控制按钮
                    HStack {
                        if mapViewModel.isNavigating {
                            Button("Stop navigation") {
                                mapViewModel.stopNavigation()
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(15)
                        } else {
                            Button("Start navigation") {
                                // 重新启用陀螺仪
                                let motionManager = MotionManager.shared
                                if !motionManager.isMotionActive {
                                    motionManager.startMotionUpdates()
                                    motionManager.startHeadingUpdates()
                                }
                                mapViewModel.enableDeviceHeadingTracking(motionManager)
                                mapViewModel.startNavigation()
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(15)
                        }
                        
                        Spacer()
                        
                        // 路线类型指示器
                        HStack(spacing: 4) {
                            Image(systemName: transportTypeIcon)
                                .font(.caption)
                            Text(mapViewModel.routeTransportType.localizedDescription)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            
            // 当前导航指令 - 只在导航模式下显示
            if mapViewModel.isNavigating, let instruction = mapViewModel.currentInstruction {
                HStack {
                    Image(systemName: "arrow.turn.up.right")
                        .foregroundColor(.blue)
                    Text(instruction)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.top, 4)
            }
            
            // 添加路线收藏按钮 - 只在非导航模式下显示
            if mapViewModel.hasRoute && !mapViewModel.isNavigating {
                Button(action: {
                    showingAddToFavoriteRoutes = true
                }) {
                    Label("Save route", systemImage: "star")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 公交换乘信息简要显示
    private func transitInfoSection(_ route: MKRoute) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "tram.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("Transfer information")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            // 显示简化的换乘步骤
            let simplifiedSteps = getSimplifiedTransitSteps(for: route)
            
            if !simplifiedSteps.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(Array(simplifiedSteps.prefix(5).enumerated()), id: \.offset) { index, stepText in
                        HStack(spacing: 6) {
                            Text("•")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            Text(stepText)
                                .font(.caption2)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    if simplifiedSteps.count > 5 {
                        Text("There are \(simplifiedSteps.count - 5) transfer steps...")
                            .font(.caption2)
                            .foregroundColor(.primary)
                    }
                }
            } else {
                Text("Includes public transport routes")
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
    
    // 获取简化的换乘步骤
    private func getSimplifiedTransitSteps(for route: MKRoute) -> [String] {
        var simplifiedSteps: [String] = []
        
        for step in route.steps {
            let instruction = step.instructions
            
            // 如果是步行
            if instruction.contains("Walk") || instruction.contains("go") || step.transportType == .walking {
                let minutes = Int(step.distance / 80) // 假设步行速度80米/分钟
                let walkTime = max(1, minutes) // 至少1分钟
                simplifiedSteps.append("\(walkTime) minutes walking")
            }
            // 如果是公交/地铁
            else if instruction.contains("Take") || instruction.contains("board") || step.transportType == .transit {
                if let lineInfo = extractSimpleLineInfo(from: instruction) {
                    simplifiedSteps.append(lineInfo)
                } else if instruction.contains("subway") {
                    simplifiedSteps.append("Subway")
                } else if instruction.contains("bus") {
                    simplifiedSteps.append("Bus")
                } else {
                    simplifiedSteps.append("Public transport")
                }
            }
            // 其他交通方式
            else if !instruction.isEmpty && step.distance > 10 { // 只有距离大于10米的步骤才显示
                simplifiedSteps.append(String(instruction.prefix(8)))
            }
        }
        
        return simplifiedSteps
    }
    
    // 提取简单的线路信息
    private func extractSimpleLineInfo(from instruction: String) -> String? {
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
    
    // 交通状况颜色
    private var trafficColor: Color {
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

    // 交通工具图标
    private var transportTypeIcon: String {
        switch mapViewModel.routeTransportType {
        case .automobile:
            return "car.fill"
        case .walking:
            return "figure.walk"
        case .transit:
            return "tram.fill"
        default:
            return "location.fill"
        }
}

    // 底部控制视图
    private var bottomControlsView: some View {
        VStack {
            if mapViewModel.isNavigating {
                // 导航模式下的控制
                navigationControls
            } else {
                // 普通模式下的控制
                normalControls
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
    
    // 导航控制
    private var navigationControls: some View {
        HStack {
            Button(action: {
                mapViewModel.stopNavigation()
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.red)
                    .cornerRadius(25)
            }
            
            Spacer()
            
            if let instruction = mapViewModel.currentInstruction {
                VStack {
                    Text(instruction)
                    .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    if let distance = mapViewModel.distanceToNextInstruction {
                        Text("\(Int(distance)) meters away")
                    .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
            }
            
            Spacer()
            
            Button(action: {
                mapViewModel.recenterOnRoute()
            }) {
                Image(systemName: "location.north.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
        }
    }
    
    // 普通控制
    private var normalControls: some View {
        HStack {
            Button(action: {
                mapViewModel.centerOnUserLocation(locationManager.location)
            }) {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(radius: 3)
            }
            
            Spacer()
    }
}

    // 处理搜索提交（按Enter键）
    private func handleSearchSubmit() {
        guard !searchText.isEmpty else { return }
        
        // 显示路线规划栏
        showingRoutePlanning = true
        showingSearchResults = false
        currentDestinationName = searchText
        
        // 开始搜索第一个匹配结果并导航
        searchAndNavigateToFirstResult()
    }
    
    // 搜索并导航到第一个结果
    private func searchAndNavigateToFirstResult() {
        guard !searchText.isEmpty else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // 如果有用户位置，以用户位置为中心搜索
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response, let firstResult = response.mapItems.first {
                    // 使用第一个搜索结果进行导航
                    self.currentDestinationName = firstResult.name ?? self.searchText
                    self.startNavigationToDestination(firstResult)
                } else {
                    // 搜索失败，显示错误信息
                    print("Search failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.showingRoutePlanning = false
                }
            }
        }
    }
    
    // 搜索地点
    private func searchLocation() {
        guard !searchText.isEmpty && searchText.count >= 2 else { 
            searchResults = []
            showingSearchResults = false
            return 
        }
        
        // 如果正在输入中，不开始搜索
        if isTyping {
            return
        }
        
        isSearching = true
        showingSearchResults = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // 如果有用户位置，以用户位置为中心搜索
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                // 检查搜索文本是否还是一样的（避免过期结果）
                guard !self.searchText.isEmpty && self.searchText.count >= 2 else {
                    self.isSearching = false
                    return
                }
                
                self.isSearching = false
                
                if let response = response {
                    self.searchResults = response.mapItems
                } else {
                    self.searchResults = []
                    if let error = error {
                        print("Search failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // 选择目的地并开始导航
    private func selectDestinationAndStartNavigation(_ destination: MKMapItem) {
        // 隐藏搜索结果，显示路线规划栏
        showingSearchResults = false
        showingRoutePlanning = true
        searchText = destination.name ?? "Destination"
        currentDestinationName = destination.name ?? "Destination"
        
        // 开始导航
        startNavigationToDestination(destination)
    }
    
    // 开始导航到指定目的地
    private func startNavigationToDestination(_ destination: MKMapItem) {
        // 设置目的地
        selectedDestination = destination
        currentDestinationName = destination.name ?? "Destination"
        
        // 设置目的地标注
        mapViewModel.selectDestination(coordinate: destination.placemark.coordinate, title: destination.name ?? "Destination")
        
        // 开始规划路线，使用当前位置作为起点
        if let userLocation = locationManager.location {
            let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            originItem.name = "My location"
            mapViewModel.calculateRouteWithOptions(from: originItem, to: destination) { success in
                if success {
                    print("Route planning successful")
                } else {
                    print("Route planning failed")
                }
            }
        } else {
            mapViewModel.calculateRouteAndStartNavigation(to: destination)
        }
    }
    
    // 格式化距离
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f meters", distance)
        } else {
            return String(format: "%.1f kilometers", distance / 1000)
        }
    }
    
    // 格式化时间
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours) hours \(minutes) minutes"
        } else {
            return "\(minutes) minutes"
        }
    }
    
    // 格式化ETA
    private func formatETA(_ eta: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: eta)
    }
    
    // 权限状态描述
    private func permissionStatusDescription() -> String {
        guard let status = locationManager.locationStatus else { return "Unknown" }
        switch status {
        case .notDetermined:
            return "Not determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "Always allowed"
        case .authorizedWhenInUse:
            return "Allowed when in use"
        @unknown default:
            return "Unknown status"
        }
    }
    
    // 请求位置权限
    private func requestLocationPermissionIfNeeded() {
        print("Checking location permission status: \(locationManager.locationStatus?.rawValue ?? -1)")
        
        switch locationManager.locationStatus {
        case .notDetermined:
            print("Location permission not determined, requesting...")
            locationManager.requestLocationPermission()
        case .denied, .restricted:
            print("Location permission denied/restricted, showing alert")
            showingLocationPermissionAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted, checking if we have location")
            // 如果已经有权限但没有位置，重新请求
            if locationManager.location == nil {
                locationManager.requestLocationPermission()
            }
        case .none:
            print("Location status unknown, requesting permission")
            locationManager.requestLocationPermission()
        @unknown default:
            print("Unknown location status, requesting permission")
            locationManager.requestLocationPermission()
        }
    }
    
    // 打开位置设置
    private func openLocationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    // 搜索起点位置
    private func searchOriginLocation() {
        guard !originSearchText.isEmpty else {
            originSearchResults = []
            showingOriginResults = false
            return
        }
        
        showingOriginResults = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = originSearchText
        
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    self.originSearchResults = response.mapItems
                } else {
                    self.originSearchResults = []
                }
            }
        }
    }
    
    // 搜索终点位置
    private func searchDestinationLocation() {
        guard !destinationSearchText.isEmpty else {
            destinationSearchResults = []
            showingDestinationResults = false
            return
        }
        
        showingDestinationResults = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationSearchText
        
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    self.destinationSearchResults = response.mapItems
                } else {
                    self.destinationSearchResults = []
                }
            }
    }
}

    // 选择起点
    private func selectOrigin(_ item: MKMapItem) {
        selectedOrigin = item
        currentOriginName = item.name ?? "Start"
        isEditingOrigin = false
        showingOriginResults = false
        originSearchText = ""
        
        // 同时更新MapViewModel中的起点信息
        mapViewModel.selectedOrigin = item
        
        print("Selected start: \(currentOriginName)")
    }
    
    // 选择终点
    private func selectDestination(_ item: MKMapItem) {
        selectedDestination = item
        currentDestinationName = item.name ?? "Destination"
        isEditingDestination = false
        showingDestinationResults = false
        destinationSearchText = ""
        
        // 同时更新MapViewModel中的终点信息
        mapViewModel.selectedDestination = item
        
        // 设置地图上的终点标注
        mapViewModel.selectDestination(coordinate: item.placemark.coordinate, title: item.name ?? "Destination")
        
        print("Selected destination: \(currentDestinationName)")
    }
    
    // 从起点到终点计算路线
    private func calculateRouteFromOriginToDestination() {
        print("Start calculating route - start: \(currentOriginName), destination: \(currentDestinationName)")
        
        // 确定终点
        if let destination = selectedDestination {
            // 如果已经选择了具体的终点，直接使用
            calculateRouteWithDestination(destination)
        } else if !currentDestinationName.isEmpty {
            // 如果只有终点名称，先搜索然后计算路线
            searchAndCalculateRoute(destinationName: currentDestinationName)
        } else {
            print("No valid destination")
            return
        }
    }
    
    // 使用已确定的终点计算路线
    private func calculateRouteWithDestination(_ destination: MKMapItem) {
        // 确定起点
        if let origin = selectedOrigin {
            // 使用选择的起点
            print("Using selected start: \(origin.name ?? "Unknown")")
            mapViewModel.calculateRouteWithOptions(from: origin, to: destination) { success in
                DispatchQueue.main.async {
                    print("Route planning result: \(success ? "Success" : "Failed")")
                }
            }
        } else if currentOriginName == "My location", let userLocation = locationManager.location {
            // 使用当前位置作为起点
            let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            originItem.name = "My location"
            
            // 同时设置到变量中，保持一致性
            selectedOrigin = originItem
            mapViewModel.selectedOrigin = originItem
            
            print("Using current location as start")
            mapViewModel.calculateRouteWithOptions(from: originItem, to: destination) { success in
                DispatchQueue.main.async {
                    print("Route planning result: \(success ? "Success" : "Failed")")
                }
            }
        } else {
            print("Cannot get valid start location")
        }
    }
    
    // 搜索并计算路线（用于处理只有名称没有选择具体地点的情况）
    private func searchAndCalculateRoute(destinationName: String) {
        print("Search destination: \(destinationName)")
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationName
        
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response, let firstResult = response.mapItems.first {
                    print("Found destination: \(firstResult.name ?? "Unknown location")")
                    // 设置找到的终点
                    self.selectedDestination = firstResult
                    self.currentDestinationName = firstResult.name ?? destinationName
                    
                    // 更新MapViewModel中的终点
                    self.mapViewModel.selectedDestination = firstResult
                    
                    // 现在计算路线
                    self.calculateRouteWithDestination(firstResult)
                } else {
                    print("Search destination failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    // 添加路线收藏视图
    private var addToFavoriteRoutesView: some View {
        NavigationView {
            Form {
                Section(header: Text("Route information")) {
                    TextField("Route name", text: $favoriteRouteName)
                        .overlay(
                            Group {
                                if favoriteRouteName.isEmpty {
                                    HStack {
                                        Spacer()
                                        Text("Enter route name")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .padding(.trailing, 4)
                                    }
                                }
                            }
                        )
                    
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                        Text(currentOriginName)
                    }
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                        Text(currentDestinationName)
                    }
                }
            }
            .navigationTitle("Save route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddToFavoriteRoutes = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCurrentRoute()
                        showingAddToFavoriteRoutes = false
                    }
                    .disabled(favoriteRouteName.isEmpty)
                }
            }
        }
    }
    
    // 保存当前路线
    private func saveCurrentRoute() {
        guard let origin = selectedOrigin ?? (currentOriginName == "My location" ? MKMapItem.forCurrentLocation() : nil),
              let destination = selectedDestination,
              !favoriteRouteName.isEmpty else { return }
        
        let route = FavoriteRoute(
            name: favoriteRouteName,
            originName: currentOriginName,
            destinationName: currentDestinationName,
            origin: origin.placemark.coordinate,
            destination: destination.placemark.coordinate,
            transportType: mapViewModel.routeTransportTypeString
        )
        
        favoriteRoutesManager.addFavoriteRoute(route)
        favoriteRouteName = ""
    }
    
    // 添加到收藏夹视图
    private var addToFavoritesView: some View {
        NavigationView {
            Form {
                Section(header: Text("Location information")) {
                    if let destination = selectedDestination {
                        Text(destination.name ?? "Unnamed location")
                            .font(.headline)
                        
                        Text(formatAddress(destination.placemark))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Select category", selection: $favoriteCategory) {
                        Text("Other").tag("Other")
                        Text("Home").tag("Home")
                        Text("Company").tag("Company")
                        Text("School").tag("School")
                        Text("Restaurant").tag("Restaurant")
                        Text("Shopping").tag("Shopping")
                        Text("Entertainment").tag("Entertainment")
                    }
                }
            }
            .navigationTitle("Add to favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddToFavorites = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveToFavorites()
                        showingAddToFavorites = false
                    }
                }
            }
        }
    }
    
    // 保存到收藏夹
    private func saveToFavorites() {
        guard let destination = selectedDestination else { return }
        
        let favorite = FavoriteLocation(
            name: destination.name ?? "Unnamed location",
            address: formatAddress(destination.placemark),
            coordinate: destination.placemark.coordinate,
            category: favoriteCategory
        )
        
        favoritesManager.addFavorite(favorite)
    }
    
    // 添加地址格式化函数
    private func formatAddress(_ placemark: MKPlacemark) -> String {
        var components: [String] = []
        
        if let subThoroughfare = placemark.subThoroughfare {
            components.append(subThoroughfare)
        }
        
        if let thoroughfare = placemark.thoroughfare {
            components.append(thoroughfare)
        }
        
        if let subLocality = placemark.subLocality {
            components.append(subLocality)
        }
        
        if let locality = placemark.locality {
            components.append(locality)
        } else if let administrativeArea = placemark.administrativeArea {
            components.append(administrativeArea)
        }
        
        return components.joined(separator: ", ")
    }
    
    // 获取朝向跟踪模式描述
    private func getHeadingTrackingMode() -> String {
        if !mapViewModel.followDeviceHeading {
            return "Close"
        } else if mapViewModel.isNavigating {
            return "Navigation mode"
        } else {
            return "Normal mode"
        }
    }
    
    // 搜索地址并开始导航（用于精确导航功能）
    private func searchAndNavigateToAddress(_ address: String) {
        print("🔍 Start searching address: \(address)")
        
        // 先显示路线规划栏，让用户知道正在处理
        DispatchQueue.main.async {
            print("📲 Force display route planning bar")
            self.showingRoutePlanning = true
            self.currentDestinationName = address
            self.currentOriginName = "My location"
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        
        // 如果有用户位置，以用户位置为中心搜索
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
            print("🌍 Use current location as search center: \(location.coordinate)")
        } else {
            print("⚠️ No current location information, use default search")
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response, let firstResult = response.mapItems.first {
                    print("✅ Found address: \(firstResult.name ?? address)")
                    print("📍 Address coordinates: \(firstResult.placemark.coordinate)")
                    
                    // 设置目标地点
                    self.selectedDestination = firstResult
                    self.mapViewModel.selectedDestination = firstResult
                    
                    // 设置起点为当前位置
                    if let userLocation = self.locationManager.location {
                        let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
                        originItem.name = "My location"
                        self.selectedOrigin = originItem
                        self.mapViewModel.selectedOrigin = originItem
                        print("📍 Start set to current location: \(userLocation.coordinate)")
                    }
                    
                    // 开始导航路线规划
                    print("🚗 Start route planning")
                    self.startNavigationToDestination(firstResult)
                } else {
                    print("❌ Search address failed: \(error?.localizedDescription ?? "Unknown error")")
                    print("❌ Error code: \((error as? NSError)?.code ?? -1)")
                    print("❌ Error domain: \((error as? NSError)?.domain ?? "Unknown")")
                    
                    // 即使搜索失败，也要保持路线规划栏显示，并提供备用方案
                    print("📲 Search failed, but keep route planning bar displayed")
                    
                    // 尝试创建一个基于名称的地址（备用方案）
                    print("🔄 Try to create a location based on the address name")
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(address) { placemarks, error in
                        DispatchQueue.main.async {
                            if let placemark = placemarks?.first,
                               let location = placemark.location {
                                print("✅ Geocoding successful: \(location.coordinate)")
                                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                                mapItem.name = address
                                
                                self.selectedDestination = mapItem
                                self.mapViewModel.selectedDestination = mapItem
                                
                                // 设置起点为当前位置
                                if let userLocation = self.locationManager.location {
                                    let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
                                    originItem.name = "My location"
                                    self.selectedOrigin = originItem
                                    self.mapViewModel.selectedOrigin = originItem
                                }
                                
                                self.startNavigationToDestination(mapItem)
                            } else {
                                print("❌ Geocoding also failed: \(error?.localizedDescription ?? "Unknown error")")
                                // 显示错误提示但保持界面显示
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 搜索并设置起点（新增）
    private func searchAndSetOrigin(_ originName: String, completion: (() -> Void)? = nil) {
        print("🔍 Search start: \(originName)")
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = originName
        
        // 如果有用户位置，以用户位置为中心搜索
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response, let firstResult = response.mapItems.first {
                    print("✅ Found start: \(firstResult.name ?? originName)")
                    self.selectedOrigin = firstResult
                    self.mapViewModel.selectedOrigin = firstResult
                } else {
                    print("❌ Search start failed: \(error?.localizedDescription ?? "Unknown error")")
                    // 如果搜索失败，使用当前位置
                    if let userLocation = self.locationManager.location {
                        let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))   
                        originItem.name = "My location"
                        self.selectedOrigin = originItem
                        self.mapViewModel.selectedOrigin = originItem
                    }
                }
                
                // 完成回调
                completion?()
            }
        }
    }
}

// MARK: - 地图视图
struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var favoritesManager: FavoritesManager
    let selectedMapType: MKMapType
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = selectedMapType
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none  // 初始为不跟踪，通过代码控制
        mapView.showsCompass = true
        mapView.showsScale = true
        
        // 配置地图视图
        mapView.isRotateEnabled = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        
        // 设置用户位置显示模式，允许显示朝向
        mapView.showsUserLocation = true
        if #available(iOS 14.0, *) {
            mapView.showsUserTrackingButton = false  // 隐藏系统的跟踪按钮
        }
        
        mapViewModel.mapView = mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = selectedMapType
        
        // 更新路线
        if let route = mapViewModel.currentRoute {
            // 只有当路线真正改变时才更新
            let existingRouteOverlays = uiView.overlays.filter { !($0 is UserHeadingOverlay) }
            if existingRouteOverlays.isEmpty {
                uiView.addOverlay(route.polyline)
                
                // 设置地图视图以显示整个路线（仅在非导航模式下）
                if !mapViewModel.isNavigating {
                    uiView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                }
            }
        }
        
        // 更新标注 - 减少不必要的更新
        let currentAnnotations = uiView.annotations.filter { !($0 is MKUserLocation) }
        if currentAnnotations.count != mapViewModel.annotations.count {
            uiView.removeAnnotations(currentAnnotations)
            uiView.addAnnotations(mapViewModel.annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // 添加地图区域变化检测
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            // 检测用户手动移动地图
            if parent.mapViewModel.isNavigating {
                parent.mapViewModel.detectUserManualMapMove()
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            print("🎨 Renderer requested for overlay type: \(type(of: overlay))")
            
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                // 在第一人称视角下使用更亮的蓝色和更粗的线条
                if parent.mapViewModel.isFirstPersonView {
                    renderer.strokeColor = UIColor.systemBlue  // 第一人称视角用亮蓝色
                    renderer.lineWidth = 10  // 进一步增加线宽
                    renderer.alpha = 0.9     // 稍微透明以不过分抢眼
                } else {
                    renderer.strokeColor = UIColor.systemBlue
                    renderer.lineWidth = 6
                    renderer.alpha = 1.0
                }
                
                // 添加边框效果使路线更明显
                renderer.lineCap = .round
                renderer.lineJoin = .round
                
                print("✅ Created polyline renderer - First person: \(parent.mapViewModel.isFirstPersonView), Width: \(renderer.lineWidth)")
                return renderer
            } else if let headingOverlay = overlay as? UserHeadingOverlay {
                // 处理自定义朝向指示器
                print("✅ Creating UserHeadingOverlayRenderer for heading: \(headingOverlay.heading)°")
                return UserHeadingOverlayRenderer(overlay: headingOverlay)
            }
            
            print("⚠️ Using default renderer for unknown overlay type")
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                // 添加收藏按钮
                let favoriteButton = UIButton(type: .system)
                let coordinate = annotation.coordinate
                let isFavorite = parent.favoritesManager.favorites.contains { favorite in
                    return abs(favorite.coordinate.latitude - coordinate.latitude) < 0.0001 &&
                           abs(favorite.coordinate.longitude - coordinate.longitude) < 0.0001
                }
                favoriteButton.setImage(UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
                favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                favoriteButton.tintColor = isFavorite ? .systemYellow : .systemBlue
                annotationView?.rightCalloutAccessoryView = favoriteButton
                
                // 添加导航按钮
                let navigateButton = UIButton(type: .system)
                navigateButton.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
                navigateButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                annotationView?.leftCalloutAccessoryView = navigateButton
            }
            
            // 设置标注颜色
            if annotation.subtitle == "Destination" {
                annotationView?.markerTintColor = .red
            } else if annotation.subtitle == "Start" {
                annotationView?.markerTintColor = .green
            } else {
                annotationView?.markerTintColor = .blue
            }
            
            annotationView?.annotation = annotation
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation else { return }
            
            if control == view.rightCalloutAccessoryView {
                // 收藏按钮被点击
                let location = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
                location.name = annotation.title ?? "Unnamed location"
                
                // 检查是否已经收藏
                let isFavorite = parent.favoritesManager.favorites.contains { favorite in
                    return abs(favorite.coordinate.latitude - annotation.coordinate.latitude) < 0.0001 &&
                           abs(favorite.coordinate.longitude - annotation.coordinate.longitude) < 0.0001
                }
                
                if isFavorite {
                    // 如果已收藏，则移除收藏
                    let favoriteToRemove = parent.favoritesManager.favorites.first { favorite in
                        return abs(favorite.coordinate.latitude - annotation.coordinate.latitude) < 0.0001 &&
                               abs(favorite.coordinate.longitude - annotation.coordinate.longitude) < 0.0001
                    }
                    if let favorite = favoriteToRemove {
                        parent.favoritesManager.removeFavorite(withId: favorite.id)
                        if let button = control as? UIButton {
                            button.setImage(UIImage(systemName: "star"), for: .normal)
                            button.tintColor = .systemBlue
                        }
                    }
                } else {
                    // 如果未收藏，则添加收藏
                    NotificationCenter.default.post(
                        name: Notification.Name("AddToFavorites"),
                        object: nil,
                        userInfo: ["location": location]
                    )
                    if let button = control as? UIButton {
                        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        button.tintColor = .systemYellow
                    }
                }
            } else if control == view.leftCalloutAccessoryView {
                // 导航按钮被点击
                let title = (annotation.title ?? "") ?? "Destination"
                parent.mapViewModel.selectDestination(coordinate: annotation.coordinate, title: title)
                
                NotificationCenter.default.post(
                    name: Notification.Name("StartNavigation"),
                    object: nil,
                    userInfo: [
                        "coordinate": annotation.coordinate,
                        "title": title
                    ]
                )
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // 发送位置更新通知，用于更新朝向指示器
            NotificationCenter.default.post(name: NSNotification.Name("UserLocationDidUpdate"), object: nil)
        }
    }
}

// MARK: - 工具栏按钮组件
struct ToolbarButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                // 图标
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: gradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
                
                // 文字
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 100)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemBackground).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
        }
    }
}

extension NavigationAssistantView {
    // 搜索附近停车场
    private func searchNearbyParking() {
        guard let userLocation = locationManager.location else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parking"
        request.region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    self.searchResults = response.mapItems
                    self.showingSearchResults = true
                } else {
                    print("Search parking failed")
                }
            }
        }
    }
    
    // 搜索附近加油站
    private func searchNearbyGasStations() {
        guard let userLocation = locationManager.location else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Gas station"
        request.region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    self.searchResults = response.mapItems
                    self.showingSearchResults = true
                } else {
                    print("Search gas station failed")
                }
            }
        }
    }
}

struct NavigationAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationAssistantView()
    }
}