//
//  MapViewModel.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI
import Combine

class MapViewModel: NSObject, ObservableObject {
    // MARK: - Constant Definitions
    static let MY_LOCATION_TEXT = "My Location"
    
    @Published var currentRoute: MKRoute?
    @Published var alternativeRoutes: [MKRoute] = []
    @Published var isNavigating = false
    @Published var routeTransportType: MKDirectionsTransportType = .automobile
    @Published var annotations: [MKPointAnnotation] = []
    @Published var searchResults: [MKMapItem] = []
    @Published var selectedDestination: MKMapItem?
    @Published var selectedOrigin: MKMapItem?
    @Published var currentInstruction: String?
    @Published var distanceToNextInstruction: CLLocationDistance?
    @Published var errorMessage: String?
    @Published var estimatedTimeOfArrival: Date?
    @Published var remainingDistance: CLLocationDistance?
    @Published var remainingTime: TimeInterval?
    @Published var currentStepDescription: String?
    @Published var nextStepDescription: String?
    @Published var trafficCondition: String = "Normal"
    @Published var avoidTolls = false
    @Published var avoidHighways = false
    @Published var isRouteCalculating = false
    @Published var isFirstPersonView = false
    @Published var followDeviceHeading = false
    @Published var currentMapHeading: Double = 0.0
    
    // History Location Manager
    @Published var historyLocationManager = HistoryLocationManager()
    
    var mapView: MKMapView?
    private var routeCalculationTimer: Timer?
    private var navigationTimer: Timer?
    private var currentStepIndex = 0
    private var lastLocationUpdate: Date = Date()
    private var cancellables = Set<AnyCancellable>()
    
    // Add location change threshold control
    private var lastHeadingUpdateLocation: CLLocation?
    private let headingUpdateDistanceThreshold: CLLocationDistance = 10.0 // Increase to 50 meters threshold, reduce update frequency
    
    // Add time control
    private var lastHeadingUpdateTime: Date = Date()
    private let headingUpdateTimeThreshold: TimeInterval = 2.0 // Minimum 2 seconds interval
    
    // Add user manual map move detection
    private var userHasManuallyMovedMap = false
    private var lastAutoCenterTime: Date = Date()
    private let manualMoveDetectionThreshold: TimeInterval = 2.0 // Move within 2 seconds is considered manual
    
    // Camera control parameters
    private let navigationPitch: CGFloat = 60 // Tilt angle for navigation
    private let navigationAltitude: CLLocationDistance = 250 // Height for navigation
    private let navigationHeadingStep: CLLocationDirection = 20 // Step length for smooth transition
    
    var hasRoute: Bool {
        currentRoute != nil
    }
    
    var routeTransportTypeString: String {
        switch routeTransportType {
        case .automobile:
            return "driving"
        case .walking:
            return "walking"
        case .transit:
            return "transit"
        default:
            return "driving"
        }
    }
    
    // MARK: - Location Search
    func searchLocation(_ query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        // Limit search to current map area
        if let mapView = mapView {
            request.region = mapView.region
        }
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            DispatchQueue.main.async {
                if let response = response {
                    self?.searchResults = response.mapItems
                } else {
                    self?.searchResults = []
                    if let error = error {
                        self?.errorMessage = "Search failed: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    // MARK: - Destination Selection
    func selectDestination(coordinate: CLLocationCoordinate2D, title: String) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        selectedDestination = mapItem
        
        // Add to history location (get detailed address)
        addToHistoryLocation(coordinate: coordinate, title: title)
        
        // Add or update destination annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = "Destination"
        
        // Remove previous destination annotation
        if let mapView = mapView {
            let existingAnnotations = mapView.annotations.filter { 
                $0.subtitle == "Destination" && !($0 is MKUserLocation) 
            }
            mapView.removeAnnotations(existingAnnotations)
            mapView.addAnnotation(annotation)
        }
        
        annotations.append(annotation)
    }
    
    // Add location to history
    private func addToHistoryLocation(coordinate: CLLocationCoordinate2D, title: String) {
        // Use reverse geocoding to get detailed address
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                var address = "Location information not available"
                
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
                    
                    if !addressComponents.isEmpty {
                        address = addressComponents.joined(separator: ", ")
                    }
                }
                
                // Add to history
                self?.historyLocationManager.addHistoryLocation(
                    name: title,
                    address: address,
                    coordinate: coordinate
                )
            }
        }
    }
    
    // MARK: - Route Planning
    func calculateRoute(to destination: MKMapItem) {
        guard let mapView = mapView,
              let userLocation = mapView.userLocation.location else {
            errorMessage = "Cannot get current location"
            return
        }
        
        isRouteCalculating = true
        errorMessage = nil
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = destination
        request.transportType = routeTransportType
        request.requestsAlternateRoutes = true
        
        // Add route preference settings
        if routeTransportType == .automobile {
            // Can add avoiding toll roads etc settings here
        }
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            DispatchQueue.main.async {
                self?.isRouteCalculating = false
                
                if let error = error {
                    self?.errorMessage = "Location route planning failed: \(error.localizedDescription)"
                    return
                }
                
                guard let response = response else {
                    self?.errorMessage = "No available route found"
                    return
                }
                
                // Set main route and alternate routes
                if let primaryRoute = response.routes.first {
                    self?.currentRoute = primaryRoute
                    self?.alternativeRoutes = Array(response.routes.dropFirst())
                    self?.calculateETAAndRemainingInfo(for: primaryRoute)
                    self?.errorMessage = nil
                    
                    // Validate if the route matches the requested transport type
                    self?.validateRouteTransportType(route: primaryRoute)
                    
                    // Voice prompt route found
                    self?.announceRouteFound(route: primaryRoute)
                }
            }
        }
    }
    
    // Calculate route and automatically start navigation
    func calculateRouteAndStartNavigation(to destination: MKMapItem) {
        guard let mapView = mapView,
              let userLocation = mapView.userLocation.location else {
            errorMessage = "Cannot get current location"
            return
        }
        
        isRouteCalculating = true
        errorMessage = nil
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = destination
        request.transportType = routeTransportType
        request.requestsAlternateRoutes = true
        
        // Add route preference settings
        if routeTransportType == .automobile {
            // Can add avoiding toll roads etc settings here
        }
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            DispatchQueue.main.async {
                self?.isRouteCalculating = false
                
                if let error = error {
                    self?.errorMessage = "Location route planning failed: \(error.localizedDescription)"
                    return
                }
                
                guard let response = response else {
                    self?.errorMessage = "No available route found"
                    return
                }
                
                // Set main route and alternate routes
                if let primaryRoute = response.routes.first {
                    self?.currentRoute = primaryRoute
                    self?.alternativeRoutes = Array(response.routes.dropFirst())
                    self?.calculateETAAndRemainingInfo(for: primaryRoute)
                    self?.errorMessage = nil
                    
                    // Validate if the route matches the requested transport type
                    self?.validateRouteTransportType(route: primaryRoute)
                    
                    // Voice prompt route found
                    self?.announceRouteFound(route: primaryRoute)
                }
            }
        }
    }
    
    // Calculate expected arrival time and remaining information
    private func calculateETAAndRemainingInfo(for route: MKRoute) {
        let now = Date()
        estimatedTimeOfArrival = now.addingTimeInterval(route.expectedTravelTime)
        remainingDistance = route.distance
        remainingTime = route.expectedTravelTime
        
        // Analyze traffic condition
        analyzeTrafficCondition(for: route)
    }
    
    // Analyze traffic condition
    private func analyzeTrafficCondition(for route: MKRoute) {
        // Based on route expected time and distance estimate traffic condition
        let averageSpeed = route.distance / route.expectedTravelTime * 3.6 // km/h
        
        switch routeTransportType {
        case .automobile:
            if averageSpeed > 40 {
                trafficCondition = "Smooth"
            } else if averageSpeed > 20 {
                trafficCondition = "Slow"
            } else {
                trafficCondition = "Congested"
            }
        case .walking:
            trafficCondition = "Walking"
        case .transit:
            trafficCondition = "Bus"
        default:
            trafficCondition = "Normal"
        }
    }
    
    // Voice prompt route found
    private func announceRouteFound(route: MKRoute) {
        let distance = formatDistance(route.distance)
        let time = formatDuration(route.expectedTravelTime)
        currentInstruction = "Your route has been planned. The total distance is approximately \(distance)，预计\(time)"
    }
    
    // MARK: - Navigation Control
    func startNavigation() {
        guard currentRoute != nil else { return }
        
        // When starting navigation, if there is no user-defined start location, automatically set to "My Location"
        if selectedOrigin == nil, let mapView = mapView, let userLocation = mapView.userLocation.location {
            // MKDirections will automatically align this coordinate to the nearest road (Map Matching)
            let originItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            originItem.name = MapViewModel.MY_LOCATION_TEXT
            selectedOrigin = originItem
            
            // Add start annotation
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = userLocation.coordinate
            startAnnotation.title = MapViewModel.MY_LOCATION_TEXT
            startAnnotation.subtitle = "Start"
            
            // Check if start annotation already exists, avoid duplicate addition
            let existingOriginAnnotations = annotations.filter { $0.subtitle == "Start" }
            if existingOriginAnnotations.isEmpty {
                annotations.append(startAnnotation)
                mapView.addAnnotation(startAnnotation)
            }
            
            print("📍 Use map user location as start: \(userLocation.coordinate)")
            print("🛣️ MKDirections will automatically align to the nearest road")
        }
        
        isNavigating = true
        currentStepIndex = 0
        updateNavigationInstruction()
        
        // Automatically switch to first-person view
        if !isFirstPersonView {
            print("🔄 Automatically switch to first-person view for navigation")
            toggleFirstPersonView()
        }
        
        // Delay a bit, let map switch to first-person view before adjusting camera
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.adjustCameraForNavigation()
        }
        
        // Automatically enable heading tracking (if not already enabled)
        if !followDeviceHeading {
            print("🧭 Auto-enabling heading tracking for navigation")
            // Ensure MotionManager is started
            let motionManager = MotionManager.shared
            if !motionManager.isMotionActive {
                motionManager.startMotionUpdates()
                motionManager.startHeadingUpdates()
            }
            enableDeviceHeadingTracking(motionManager)
        } else if followDeviceHeading {
            print("🔄 Continuing heading tracking in navigation mode")
            // Continue using existing heading tracking, no need to reset
        }
        
        // Reset user manual map move state
        userHasManuallyMovedMap = false
        
        // Start navigation timer - Further reduce update frequency to reduce CPU usage
        navigationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateNavigationProgress()
            // No longer automatically update camera unless user manually moved
            if let self = self, !self.userHasManuallyMovedMap {
                self.updateNavigationCamera()
            }
        }
    }
    
    // Adjust camera angle for navigation, let blue route center
    private func adjustCameraForNavigation() {
        guard let mapView = mapView,
              let route = currentRoute,
              let userLocation = mapView.userLocation.location else { return }
        
        print("🎥 Adjust navigation camera view to center the route")
        
        // Get route direction
        let routeCoordinates = route.polyline.coordinates()
        guard routeCoordinates.count > 1 else { return }
        
        // Find user's current location closest route point
        var closestPointIndex = 0
        var shortestDistance = CLLocationDistanceMax
        
        for (index, coordinate) in routeCoordinates.enumerated() {
            let routeLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = userLocation.distance(from: routeLocation)
            if distance < shortestDistance {
                shortestDistance = distance
                closestPointIndex = index
            }
        }
        
        // Calculate forward route direction, use farther point for more accurate direction
        var heading: CLLocationDirection = 0
        let lookAheadPoints = min(10, routeCoordinates.count - closestPointIndex - 1) // Look ahead 10 points
        
        if lookAheadPoints > 0 {
            let currentPoint = routeCoordinates[closestPointIndex]
            let nextPoint = routeCoordinates[closestPointIndex + lookAheadPoints]
            
            let deltaLat = nextPoint.latitude - currentPoint.latitude
            let deltaLon = nextPoint.longitude - currentPoint.longitude
            
            // Calculate heading (clockwise from north)
            heading = atan2(deltaLon, deltaLat) * 180 / .pi
            if heading < 0 {
                heading += 360
            }
        }
        
        // Create camera, set suitable pitch and height, let route face up
        let camera = MKMapCamera(
            lookingAtCenter: userLocation.coordinate,
            fromDistance: 300, // Close distance, suitable for navigation
            pitch: 65, // Large pitch angle, close to first-person
            heading: heading // Route direction, let route face up
        )
        
        // Smoothly set camera
        UIView.animate(withDuration: 1.0) {
            mapView.setCamera(camera, animated: false)
        }
        
        print("🎯 Set navigation camera - position: \(userLocation.coordinate), heading: \(heading)°, pitch: 65°")
    }
    
    func stopNavigation() {
        isNavigating = false
        navigationTimer?.invalidate()
        navigationTimer = nil
        currentInstruction = nil
        currentStepDescription = nil
        nextStepDescription = nil
        distanceToNextInstruction = nil
        
        // If heading tracking is enabled, continue, no need to switch mode
        if followDeviceHeading {
            print("🔄 Keeping heading tracking enabled after navigation")
            // Keep existing heading tracking state
        }
        
        // No longer automatically switch view, let user manually control
        // if isFirstPersonView {
        //     toggleFirstPersonView()
        // }
        
        // Reset user manual map move state
        userHasManuallyMovedMap = false
    }
    
    func recenterOnRoute() {
        guard let mapView = mapView,
              let route = currentRoute else { return }
        
        // Reset user manual map move state, allow automatic tracking
        userHasManuallyMovedMap = false
        lastAutoCenterTime = Date()
        
        // If navigating, focus to user's current location route segment
        if isNavigating, let userLocation = mapView.userLocation.location {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: 2000,
                longitudinalMeters: 2000
            )
            mapView.setRegion(region, animated: true)
        } else {
            // Otherwise display entire route
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: true
            )
        }
        
        print("🎯 Map recentered by user, auto-tracking resumed")
    }
    
    // MARK: - New: Route Alignment Method
    func alignCameraWithRoute() {
        guard let mapView = mapView,
              let route = currentRoute,
              let userLocation = mapView.userLocation.location else { return }
        
        print("🎯 Start route alignment...")
        
        // Get route direction
        let routeCoordinates = route.polyline.coordinates()
        guard routeCoordinates.count > 1 else { return }
        
        // Find user's current location closest route point
        var closestPointIndex = 0
        var shortestDistance = CLLocationDistanceMax
        
        for (index, coordinate) in routeCoordinates.enumerated() {
            let routeLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = userLocation.distance(from: routeLocation)
            if distance < shortestDistance {
                shortestDistance = distance
                closestPointIndex = index
            }
        }
        
        // Calculate forward route direction, use farther point for more accurate direction
        var heading: CLLocationDirection = 0
        let lookAheadPoints = min(10, routeCoordinates.count - closestPointIndex - 1)
        
        if lookAheadPoints > 0 {
            let currentPoint = routeCoordinates[closestPointIndex]
            let nextPoint = routeCoordinates[closestPointIndex + lookAheadPoints]
            
            let deltaLat = nextPoint.latitude - currentPoint.latitude
            let deltaLon = nextPoint.longitude - currentPoint.longitude
            
            // Calculate heading (clockwise from north)
            heading = atan2(deltaLon, deltaLat) * 180 / .pi
            if heading < 0 {
                heading += 360
            }
        }
        
        // Calculate camera center point, let user position display in lower part of screen
        let userCoordinate = userLocation.coordinate
        let distance: CLLocationDistance = 800 // Camera to user distance
        let offsetDistance: CLLocationDistance = 300 // User position front offset distance
        
        // Calculate camera center point based on route direction (user front position)
        let headingRadians = heading * .pi / 180
        let offsetLatitude = offsetDistance * cos(headingRadians) / 111111.0 // Latitude per degree about 111111 meters
        let offsetLongitude = offsetDistance * sin(headingRadians) / (111111.0 * cos(userCoordinate.latitude * .pi / 180))
        
        let cameraCenter = CLLocationCoordinate2D(
            latitude: userCoordinate.latitude + offsetLatitude,
            longitude: userCoordinate.longitude + offsetLongitude
        )
        
        // Create route-aligned camera, user position will display in lower part of screen
        let camera = MKMapCamera(
            lookingAtCenter: cameraCenter, // Camera look at user front
            fromDistance: distance,
            pitch: isFirstPersonView ? 65 : 45,
            heading: heading // Let route face up
        )
        
        // Smoothly set camera
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            mapView.setCamera(camera, animated: false)
        }
        
        print("🎯 Route alignment completed - heading: \(heading)°, user position in lower part of the screen, first-person view: \(isFirstPersonView)")
    }
    
    // MARK: - Location Related
    func centerOnUserLocation(_ location: CLLocation?) {
        guard let location = location,
              let mapView = mapView else { return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    // New: Synchronize "My Location" annotation with user actual location
    func syncUserLocationToMyLocation(_ userLocation: CLLocation) {
        guard let mapView = mapView else { return }
        
        // Find existing "My Location" annotation
        let myLocationAnnotations = annotations.filter { $0.title == MapViewModel.MY_LOCATION_TEXT }
        
        // Remove old "My Location" annotation
        if !myLocationAnnotations.isEmpty {
            annotations.removeAll { $0.title == MapViewModel.MY_LOCATION_TEXT }
            mapView.removeAnnotations(myLocationAnnotations)
        }
        
        // Create new "My Location" annotation
        let myLocationAnnotation = MKPointAnnotation()
        myLocationAnnotation.coordinate = userLocation.coordinate
        myLocationAnnotation.title = MapViewModel.MY_LOCATION_TEXT
        myLocationAnnotation.subtitle = "Current location"
        
        // Add to annotation array and map
        annotations.append(myLocationAnnotation)
        mapView.addAnnotation(myLocationAnnotation)
    }
    
    func centerOnCityLevel(_ location: CLLocation) {
        guard let mapView = mapView else { return }
        
        // Set city level zoom (approximately display entire city area)
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 20000, // 20 kilometers range
            longitudinalMeters: 20000  // 20 kilometers range
        )
        
        mapView.setRegion(region, animated: true)
        
        // Get city information and display
        getCityInfo(for: location)
    }
    
    // Get city information
    private func getCityInfo(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let placemark = placemarks?.first {
                    let cityName = placemark.locality ?? placemark.administrativeArea ?? "Current location"
                    // Can display city name or other information here
                    print("Current city: \(cityName)")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func updateAnnotations(with mapItems: [MKMapItem]) {
        annotations.removeAll()
        
        for item in mapItems {
            let annotation = MKPointAnnotation()
            annotation.coordinate = item.placemark.coordinate
            annotation.title = item.name
            annotation.subtitle = item.placemark.title
            annotations.append(annotation)
        }
    }
    
    private func startNavigationTimer() {
        navigationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNavigationProgress()
        }
    }
    
    private func updateNavigationProgress() {
        guard let mapView = mapView,
              let userLocation = mapView.userLocation.location,
              let route = currentRoute else { return }
        
        // Update location update time
        lastLocationUpdate = Date()
        
        // Calculate distance to next instruction point
        let steps = route.steps
        guard currentStepIndex < steps.count else {
            // Navigation completed
            navigationCompleted()
            return
        }
        
        let currentStep = steps[currentStepIndex]
        let stepEndLocation = CLLocation(
            latitude: currentStep.polyline.coordinate.latitude,
            longitude: currentStep.polyline.coordinate.longitude
        )
        
        let distanceToStep = userLocation.distance(from: stepEndLocation)
        
        // Calculate remaining distance and time
        let remainingSteps = Array(steps.dropFirst(currentStepIndex))
        let totalRemainingDistance = remainingSteps.reduce(0) { $0 + $1.distance }
        
        DispatchQueue.main.async {
            self.distanceToNextInstruction = distanceToStep
            self.remainingDistance = totalRemainingDistance
            self.updateEstimatedTimeOfArrival()
            
            // Update current and next instruction
            self.updateStepInstructions(steps: steps)
            
            // If approaching end of current step, move to next step
            if distanceToStep < 50 { // 50 meters inside is considered arrived
                self.currentStepIndex += 1
                self.updateNavigationInstruction()
                
                // Voice prompt next step
                self.announceNextStep()
            }
        }
    }
    
    private func updateStepInstructions(steps: [MKRoute.Step]) {
        if currentStepIndex < steps.count {
            currentStepDescription = steps[currentStepIndex].instructions
            
            // Next instruction
            if currentStepIndex + 1 < steps.count {
                nextStepDescription = steps[currentStepIndex + 1].instructions
            } else {
                nextStepDescription = "Approaching your destination"
            }
        }
    }
    
    private func updateEstimatedTimeOfArrival() {
        guard let route = currentRoute else { return }
        
        // Recalculate ETA based on current progress
        let completedSteps = Array(route.steps.prefix(currentStepIndex))
        let completedDistance = completedSteps.reduce(0) { $0 + $1.distance }
        let progressRatio = completedDistance / route.distance
        
        let adjustedTravelTime = route.expectedTravelTime * (1 - progressRatio)
        estimatedTimeOfArrival = Date().addingTimeInterval(adjustedTravelTime)
        remainingTime = adjustedTravelTime
    }
    
    private func announceNextStep() {
        guard let route = currentRoute else { return }
        let steps = route.steps
        
        if currentStepIndex < steps.count {
            let step = steps[currentStepIndex]
            let instruction = step.instructions.isEmpty ? "Keep moving" : step.instructions
            
            // Add distance information
            if let distance = distanceToNextInstruction, distance < 200 {
                currentInstruction = "\(Int(distance)) m, \(instruction)"
            } else {
                currentInstruction = instruction
            }
        }
    }
    
    private func navigationCompleted() {
        stopNavigation()
        currentInstruction = "🎉 You have arrived!"
        
        // Can add arrival sound or vibration here
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentInstruction = nil
        }
    }
    
    private func updateNavigationInstruction() {
        guard let route = currentRoute else { return }
        
        let steps = route.steps
        guard currentStepIndex < steps.count else {
            currentInstruction = "You have arrived!"
            return
        }
        
        let step = steps[currentStepIndex]
        currentInstruction = step.instructions
        
        // If instruction is empty, use default instruction
        if currentInstruction?.isEmpty == true {
            switch currentStepIndex {
            case 0:
                currentInstruction = "Start navigation"
            case steps.count - 1:
                currentInstruction = "Approaching your destination"
            default:
                currentInstruction = "Keep moving"
            }
        }
    }
    
    // Format duration
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)hours\(minutes)minutes"
        } else {
            return "\(minutes)minutes"
        }
    }
    
    // Format distance
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0fmeters", distance)
        } else {
            return String(format: "%.1fkilometers", distance / 1000)
        }
    }
    
    // MARK: - Route Planning Enhanced
    func calculateRouteWithOptions(from startLocation: MKMapItem, to endLocation: MKMapItem, completion: @escaping (Bool) -> Void) {
        // Save start and end information
        selectedOrigin = startLocation
        selectedDestination = endLocation
        
        isRouteCalculating = true
        errorMessage = nil
        
        let request = MKDirections.Request()
        request.source = startLocation
        request.destination = endLocation
        request.transportType = routeTransportType
        request.requestsAlternateRoutes = true
        
        // Apply route preference
        if routeTransportType == .automobile {
            if avoidTolls {
                // MapKit in iOS does not have direct avoiding toll roads option, but we can mark in results
            }
            if avoidHighways {
                // Similarly, this needs to be considered when selecting route
            }
        }
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            DispatchQueue.main.async {
                self?.isRouteCalculating = false
                
                if let error = error {
                    // Special handling for transit route errors
                    if self?.routeTransportType == .transit {
                        self?.errorMessage = "No public transport routes available in this area. Try walking or driving instead."
                    } else {
                        self?.errorMessage = "Route calculation failed: \(error.localizedDescription)"
                    }
                    completion(false)
                    return
                }
                
                guard let response = response else {
                    if self?.routeTransportType == .transit {
                        self?.errorMessage = "No public transport routes available in this area"
                    } else {
                        self?.errorMessage = "Cannot get route information"
                    }
                    completion(false)
                    return
                }
                
                // Set main route
                if let primaryRoute = response.routes.first {
                    self?.currentRoute = primaryRoute
                    self?.calculateETA(for: primaryRoute)
                    self?.updateTrafficCondition(for: primaryRoute)
                    
                    // Validate if the route matches the requested transport type
                    self?.validateRouteTransportType(route: primaryRoute)
                }
                
                // Set alternate routes
                if response.routes.count > 1 {
                    self?.alternativeRoutes = Array(response.routes.dropFirst())
                }
                
                // Clear previous annotations, add new route annotations
                self?.updateRouteAnnotations(startLocation: startLocation, endLocation: endLocation)
                
                completion(true)
            }
        }
    }
    
    // Validate if the returned route matches the requested transport type
    private func validateRouteTransportType(route: MKRoute) {
        guard routeTransportType == .transit else { return }
        
        // Check if the route contains actual transit instructions
        let transitKeywords = ["bus", "subway", "metro", "train", "take", "board", "transit", "rail"]
        let hasTransitInstructions = route.steps.contains { step in
            let instruction = step.instructions.lowercased()
            return transitKeywords.contains { keyword in
                instruction.contains(keyword)
            }
        }
        
        if !hasTransitInstructions {
            // The route doesn't contain real transit instructions
            DispatchQueue.main.async {
                self.errorMessage = "⚠️ No public transport routes available. Showing alternative route instead."
            }
            print("⚠️ Warning: Requested transit route but got non-transit route")
        } else {
            print("✅ Valid transit route found with public transport instructions")
        }
    }
    
    // MARK: - Real-time Traffic and ETA Calculation
    private func calculateETA(for route: MKRoute) {
        // Calculate ETA based on current time and route expected time
        let now = Date()
        estimatedTimeOfArrival = now.addingTimeInterval(route.expectedTravelTime)
        remainingDistance = route.distance
        remainingTime = route.expectedTravelTime
    }
    
    private func updateTrafficCondition(for route: MKRoute) {
        // Simulate real-time traffic condition detection
        // In actual application, can determine traffic by comparing expectedTravelTime with ideal time
        let idealTime = route.distance / getIdealSpeed(for: routeTransportType)
        let actualTime = route.expectedTravelTime
        let ratio = actualTime / idealTime
        
        if ratio < 1.2 {
            trafficCondition = "Smooth"
        } else if ratio < 1.5 {
            trafficCondition = "Slow"
        } else {
            trafficCondition = "Congested"
        }
    }
    
    private func getIdealSpeed(for transportType: MKDirectionsTransportType) -> Double {
        switch transportType {
        case .automobile:
            return 50.0 / 3.6 // 50km/h converted to m/s
        case .walking:
            return 5.0 / 3.6  // 5km/h
        case .transit:
            return 30.0 / 3.6 // 30km/h
        default:
            return 40.0 / 3.6 // 40km/h
        }
    }
    
    // MARK: - Route Annotation Management
    private func updateRouteAnnotations(startLocation: MKMapItem, endLocation: MKMapItem) {
        guard let mapView = mapView else { return }
        
        // Clear existing annotations (keep user location)
        let annotationsToRemove = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(annotationsToRemove)
        
        // Add start annotation
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startLocation.placemark.coordinate
        startAnnotation.title = startLocation.name ?? "Start"
        startAnnotation.subtitle = "Departure"
        
        // Add end annotation
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = endLocation.placemark.coordinate
        endAnnotation.title = endLocation.name ?? "End"
        endAnnotation.subtitle = "Destination"
        
        mapView.addAnnotations([startAnnotation, endAnnotation])
        
        // Update internal annotations array
        annotations = [startAnnotation, endAnnotation]
    }
    
    // MARK: - Alternate Route Management
    func selectAlternativeRoute(_ route: MKRoute) {
        // Add current route to alternate routes
        if let currentRoute = currentRoute {
            alternativeRoutes.insert(currentRoute, at: 0)
        }
        
        // Set new main route
        currentRoute = route
        calculateETA(for: route)
        updateTrafficCondition(for: route)
        
        // Remove selected route from alternate routes
        if let index = alternativeRoutes.firstIndex(of: route) {
            alternativeRoutes.remove(at: index)
        }
    }
    
    // MARK: - Transit Transfer Information Processing
    
    // Get transit transfer summary
    func getTransitSummary() -> String? {
        guard let route = currentRoute, routeTransportType == .transit else {
            return nil
        }
        
        let transitSteps = route.steps.filter { step in
            step.instructions.contains("take") || step.instructions.contains("board") || 
            step.instructions.contains("subway") || step.instructions.contains("bus")
        }
        
        if transitSteps.count > 0 {
            let transferCount = max(transitSteps.count - 1, 0)
            if transferCount == 0 {
                return "Direct route, no transfers needed"
            } else {
                return "Transfers needed: \(transferCount)"
            }
        }
        
        return "Public transit route"
    }
    
    // Get detailed transfer steps
    func getDetailedTransitSteps() -> [TransitStepInfo] {
        guard let route = currentRoute, routeTransportType == .transit else {
            return []
        }
        
        var transitSteps: [TransitStepInfo] = []
        
        for (index, step) in route.steps.enumerated() {
            let stepInfo = TransitStepInfo(
                stepNumber: index + 1,
                instruction: step.instructions,
                distance: step.distance,
                transportType: determineStepTransportType(step),
                lineInfo: extractLineInfo(from: step.instructions),
                stationInfo: extractStationInfo(from: step.instructions)
            )
            transitSteps.append(stepInfo)
        }
        
        return transitSteps
    }
    
    private func determineStepTransportType(_ step: MKRoute.Step) -> TransitStepType {
        let instruction = step.instructions.lowercased()
        
        if instruction.contains("walk") || instruction.contains("go") {
            return .walking
        } else if instruction.contains("take") || instruction.contains("board") {
            if instruction.contains("subway") || instruction.contains("metro") {
                return .subway
            } else if instruction.contains("bus") {
                return .bus
            } else if instruction.contains("light rail") {
                return .lightRail
            } else {
                return .transit
            }
        } else {
            return .other
        }
    }
    
    private func extractLineInfo(from instruction: String) -> String? {
        // Extract line information
        if let lineRange = instruction.range(of: "take.*?line", options: .regularExpression) {
            let lineText = String(instruction[lineRange])
            return lineText.replacingOccurrences(of: "take", with: "").trimmingCharacters(in: .whitespaces)
        } else if let lineRange = instruction.range(of: "board.*?line", options: .regularExpression) {
            let lineText = String(instruction[lineRange])
            return lineText.replacingOccurrences(of: "board", with: "").trimmingCharacters(in: .whitespaces)
        }
        
        // Try to extract number+line pattern
        if let numberLineRange = instruction.range(of: "\\d+line", options: .regularExpression) {
            return String(instruction[numberLineRange])
        }
        
        return nil
    }
    
    private func extractStationInfo(from instruction: String) -> String? {
        // Extract station information
        if instruction.contains("station") {
            // Look for keywords like "to", "at", "from" followed by station name
            let separators = ["to", "at", "from"]
            for separator in separators {
                if let separatorRange = instruction.range(of: separator) {
                    let afterSeparator = String(instruction[separatorRange.upperBound...])
                    if let stationRange = afterSeparator.range(of: ".*?station", options: .regularExpression) {
                        return String(afterSeparator[stationRange]).trimmingCharacters(in: .whitespaces)
                    }
                }
            }
            
            // Directly look for station name
            if let stationRange = instruction.range(of: "[\\w\\s]+station", options: .regularExpression) {
                return String(instruction[stationRange])
            }
        }
        
        return nil
    }
    
    // MARK: - Navigation Control
    func clearRoute() {
        // Stop navigation
        stopNavigation()
        
        // Clear route
        currentRoute = nil
        alternativeRoutes = []
        
        // Clear route-related information
        estimatedTimeOfArrival = nil
        remainingDistance = nil
        remainingTime = nil
        currentStepDescription = nil
        nextStepDescription = nil
        trafficCondition = "Normal"
        
        // Clear route from map
        if let mapView = mapView {
            mapView.removeOverlays(mapView.overlays)
            // Only remove route-related annotations, keep others
            let routeAnnotations = mapView.annotations.filter { 
                ($0.subtitle == "Start" || $0.subtitle == "Destination") && !($0 is MKUserLocation)
            }
            mapView.removeAnnotations(routeAnnotations)
        }
        
        // Clear selected origin and destination
        selectedOrigin = nil
        selectedDestination = nil
    }
    
    // Transport icon
    private var transportTypeIcon: String {
        switch routeTransportType {
        case .automobile:
            return "taxi.fill"  // Modify to taxi icon
        case .walking:
            return "figure.walk"
        case .transit:
            return "tram.fill"
        default:
            return "location.fill"
        }
    }
    
    // MARK: - Navigation View Control
    func toggleFirstPersonView() {
        isFirstPersonView.toggle()
        guard let mapView = mapView else { return }
        
        if isFirstPersonView {
            // Switch to first-person view
            setupFirstPersonView(mapView)
        } else {
            // Restore to normal view
            resetToNormalView(mapView)
        }
        
        // Re-render route to apply new style
        refreshRouteRendering()
    }
    
    private func setupFirstPersonView(_ mapView: MKMapView) {
        guard let userLocation = mapView.userLocation.location else { return }
        
        // First set map type to satellite map for better 3D effect
        mapView.mapType = .hybridFlyover
        
        // Set camera, keep north not rotate, but adjust to better angle
        let camera = MKMapCamera(
            lookingAtCenter: userLocation.coordinate,
            fromDistance: 400, // Reduce height for closer view
            pitch: 45, // Reduce tilt angle, let route more obvious
            heading: 0 // Always north
        )
        
        // Smoothly transition to navigation view
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            mapView.camera = camera
        }
        
        // If there is current route, adjust view to ensure route in view
        if let route = currentRoute {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.optimizeFirstPersonRouteView(mapView: mapView, route: route, userLocation: userLocation)
            }
        }
        
        // Immediately add heading indicator
        if let userLocation = mapView.userLocation.location {
            print("📍 Adding initial heading indicator at user location")
            addUserHeadingIndicator(at: userLocation.coordinate, heading: 0.0)
            // Set initial position, avoid first update skipped
            lastHeadingUpdateLocation = userLocation
        } else {
            print("⚠️ No user location available, will add indicator when location is found")
        }
    }
    
    // New: Optimize route display in first-person view
    private func optimizeFirstPersonRouteView(mapView: MKMapView, route: MKRoute, userLocation: CLLocation) {
        // Calculate user front route point
        let userCoordinate = userLocation.coordinate
        let routeCoordinates = route.polyline.coordinates()
        
        // Find closest route point
        var nearestPointIndex = 0
        var shortestDistance = CLLocationDistance.greatestFiniteMagnitude
        
        for (index, coordinate) in routeCoordinates.enumerated() {
            let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: userLocation)
            if distance < shortestDistance {
                shortestDistance = distance
                nearestPointIndex = index
            }
        }
        
        // Get front route point for calculating view center
        let lookAheadDistance = min(nearestPointIndex + 5, routeCoordinates.count - 1)
        let targetCoordinate = routeCoordinates[lookAheadDistance]
        
        // Calculate user position and target point midpoint as view center
        let centerLatitude = (userCoordinate.latitude + targetCoordinate.latitude) / 2
        let centerLongitude = (userCoordinate.longitude + targetCoordinate.longitude) / 2
        let centerCoordinate = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        
        // Update camera view, let route face up
        let optimizedCamera = MKMapCamera(
            lookingAtCenter: centerCoordinate,
            fromDistance: 400,
            pitch: 45,
            heading: 0
        )
        
        UIView.animate(withDuration: 0.3) {
            mapView.camera = optimizedCamera
        }
        
        print("🎯 First person view optimized for route visibility")
    }
    
    private func resetToNormalView(_ mapView: MKMapView) {
        // Restore to default view
        let camera = MKMapCamera(
            lookingAtCenter: mapView.centerCoordinate,
            fromDistance: 1000,
            pitch: 0,
            heading: 0
        )
        
        // Smoothly transition back to normal view
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            mapView.camera = camera
            mapView.mapType = .standard
        }
        
        // If there is route, redisplay entire route
        if let route = currentRoute {
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: true
            )
        }
    }
    
    // Update navigation view
    private func updateNavigationCamera() {
        guard let mapView = mapView,
              let userLocation = mapView.userLocation.location,
              isFirstPersonView,
              !userHasManuallyMovedMap else { return }
        
        // Check if recently auto center, avoid frequent updates
        let timeSinceLastCenter = Date().timeIntervalSince(lastAutoCenterTime)
        if timeSinceLastCenter < manualMoveDetectionThreshold {
            print("⏰ Skipping camera update, too soon since last center")
            return
        }
        
        // Keep camera north, not follow user heading rotation
        let camera = MKMapCamera(
            lookingAtCenter: userLocation.coordinate,
            fromDistance: navigationAltitude,
            pitch: navigationPitch,
            heading: 0 // Always north
        )
        
        // Gently update view, no animation to avoid too frequent changes
        mapView.camera = camera
        
        print("📹 Navigation camera updated gently without animation")
    }
    
    // MARK: - Map Heading and Rotation
    func setMapHeading(_ heading: Double, animated: Bool = true) {
        currentMapHeading = heading
        
        guard let mapView = mapView else { return }
        
        // No longer rotate map, always keep north up, only update heading indicator
        if followDeviceHeading {
            print("🧭 Updating heading indicator to: \(heading)°, keeping map north-up")
            // Whether navigating or not, only update heading indicator, no rotate map
            updateUserHeadingIndicator(heading)
        }
        
        print("Map heading updated to: \(heading)°, Navigation: \(isNavigating), Map stays north-up")
    }
    
    func enableDeviceHeadingTracking(_ motionManager: MotionManager) {
        followDeviceHeading = true
        
        guard let mapView = mapView else { return }
        
        // Uniformly use normal tracking mode, no distinguish between navigation and normal mode
        print("✅ Device heading tracking enabled - Map stays north-up")
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        
        // Immediately add heading indicator
        if let userLocation = mapView.userLocation.location {
            print("📍 Adding initial heading indicator at user location")
            addUserHeadingIndicator(at: userLocation.coordinate, heading: 0.0)
            // Set initial position, avoid first update skipped
            lastHeadingUpdateLocation = userLocation
        } else {
            print("⚠️ No user location available, will add indicator when location is found")
        }
        
        // Listen for device heading change
        motionManager.$trueHeading
            .receive(on: DispatchQueue.main)
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true) // Limit minimum update interval to 0.5 seconds
            .sink { [weak self] heading in
                guard let self = self, self.followDeviceHeading else { return }
                
                print("📡 Received heading update: \(heading)°")
                
                // Check time interval and angle change
                let now = Date()
                let timeSinceLastUpdate = now.timeIntervalSince(self.lastHeadingUpdateTime)
                let headingDifference = abs(heading - self.currentMapHeading)
                
                // If time interval greater than 2 seconds, or angle change greater than 3 degrees and time interval greater than 0.5 seconds, then update
                if timeSinceLastUpdate >= 2.0 || (headingDifference > 3.0 && timeSinceLastUpdate >= 0.5) {
                    self.setMapHeading(heading, animated: true)
                    self.lastHeadingUpdateTime = now
                } else {
                    print("🔄 Update skipped - Time since last update: \(timeSinceLastUpdate)s, Heading change: \(headingDifference)°")
                }
            }
            .store(in: &cancellables)
            
        // Listen for location change, ensure heading indicator follow user location
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("UserLocationDidUpdate"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self, self.followDeviceHeading else { return }
            print("📍 User location updated, refreshing heading indicator")
            // Always update heading indicator
            self.updateUserHeadingIndicator(self.currentMapHeading)
        }
    }
    
    func disableDeviceHeadingTracking() {
        print("🧭 Disabling device heading tracking")
        followDeviceHeading = false
        
        // Clear all heading indicators
        if let mapView = mapView {
            let headingOverlays = mapView.overlays.filter { $0 is UserHeadingOverlay }
            mapView.removeOverlays(headingOverlays)
        }
        
        // Cancel all subscriptions
        cancellables.removeAll()
    }
    
    // New: Update custom heading indicator
    private func updateUserHeadingIndicator(_ heading: Double) {
        guard let mapView = mapView else {
            print("❌ MapView is nil")
            return
        }
        
        // Check user location
        guard let userLocation = mapView.userLocation.location else {
            print("❌ No user location available")
            return
        }
        
        // Smart update strategy: Only based on location change
        var shouldUpdate = false
        
        // Check location change
        if let lastLocation = lastHeadingUpdateLocation {
            let distance = userLocation.distance(from: lastLocation)
            if distance > headingUpdateDistanceThreshold {
                shouldUpdate = true
                print("🚶‍♂️ User moved \(Int(distance))m, updating heading indicator")
            }
        } else {
            shouldUpdate = true // First update
        }
        
        // Update for any heading change
        shouldUpdate = true
        
        if !shouldUpdate {
            print("🔄 No significant change, skipping update")
            return
        }
        
        print("🧭 Updating heading indicator: \(heading)°")
        
        // Remove old heading indicator
        removeUserHeadingIndicator()
        
        // Directly add new indicator, no delay, avoid disappearing
        print("📍 User location: \(userLocation.coordinate)")
        addUserHeadingIndicator(at: userLocation.coordinate, heading: heading)
        
        // Update last update position and time
        lastHeadingUpdateLocation = userLocation
        lastHeadingUpdateTime = Date()
    }
    
    // New: Add user heading indicator
    private func addUserHeadingIndicator(at coordinate: CLLocationCoordinate2D, heading: Double) {
        guard let mapView = mapView else {
            print("❌ MapView is nil when adding indicator")
            return
        }
        
        print("➕ Adding heading overlay at: \(coordinate) with heading: \(heading)°")
        
        // Create a fan overlay to display user heading
        let headingOverlay = UserHeadingOverlay(coordinate: coordinate, heading: heading)
        mapView.addOverlay(headingOverlay)
        
        print("✅ Heading overlay added. Total overlays: \(mapView.overlays.count)")
    }
    
    // New: Remove user heading indicator
    private func removeUserHeadingIndicator() {
        guard let mapView = mapView else {
            print("❌ MapView is nil when removing indicator")
            return
        }
        
        // Remove all heading overlays
        let headingOverlays = mapView.overlays.filter { $0 is UserHeadingOverlay }
        if !headingOverlays.isEmpty {
            print("🗑️ Removing \(headingOverlays.count) heading overlays")
            mapView.removeOverlays(headingOverlays)
        }
    }
    
    // New: Re-render route
    private func refreshRouteRendering() {
        guard let mapView = mapView, let route = currentRoute else { return }
        
        // Remove existing route overlays
        let routeOverlays = mapView.overlays.filter { !($0 is UserHeadingOverlay) }
        mapView.removeOverlays(routeOverlays)
        
        // Re-add route overlays, this will trigger new renderer
        mapView.addOverlay(route.polyline)
        
        print("🔄 Route rendering refreshed for first person view: \(isFirstPersonView)")
    }
    
    // New: Detect user manual map move
    func detectUserManualMapMove() {
        let now = Date()
        let timeSinceLastAutoCenter = now.timeIntervalSince(lastAutoCenterTime)
        
        // If distance since last auto center exceeds threshold time, user manually moved map
        if timeSinceLastAutoCenter > manualMoveDetectionThreshold {
            if !userHasManuallyMovedMap {
                userHasManuallyMovedMap = true
                print("🤏 User manually moved map, disabling auto-center")
            }
        }
    }
}

// MARK: - MKDirectionsTransportType Extension
extension MKDirectionsTransportType {
    var localizedDescription: String {
        switch self {
        case .automobile:
            return "Drive"
        case .walking:
            return "Walk"
        case .transit:
            return "Transit"
        default:
            return "Other"
        }
    }
}

// MARK: - Transit Transfer Data Structure
struct TransitStepInfo {
    let stepNumber: Int
    let instruction: String
    let distance: CLLocationDistance
    let transportType: TransitStepType
    let lineInfo: String?
    let stationInfo: String?
}

enum TransitStepType {
    case walking
    case bus
    case subway
    case lightRail
    case transit
    case other
    
    var icon: String {
        switch self {
        case .walking:
            return "figure.walk"
        case .bus:
            return "bus.fill"
        case .subway:
            return "tram.fill"
        case .lightRail:
            return "train.side.front.car"
        case .transit:
            return "tram.fill"
        case .other:
            return "location.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .walking:
            return .orange
        case .bus:
            return .green
        case .subway:
            return .blue
        case .lightRail:
            return .purple
        case .transit:
            return .blue
        case .other:
            return .gray
        }
    }
}

// MARK: - Custom User Heading Indicator Overlay Layer
class UserHeadingOverlay: NSObject, MKOverlay {
    let coordinate: CLLocationCoordinate2D
    let heading: Double
    
    init(coordinate: CLLocationCoordinate2D, heading: Double) {
        self.coordinate = coordinate
        self.heading = heading
        super.init()
    }
    
    var boundingMapRect: MKMapRect {
        // Increase boundary area to ensure larger fan fully display
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2400, longitudinalMeters: 2400) // Increase to 2400 meters range, corresponding to fan size
        let topLeft = CLLocationCoordinate2D(
            latitude: region.center.latitude + region.span.latitudeDelta / 2,
            longitude: region.center.longitude - region.span.longitudeDelta / 2
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: region.center.latitude - region.span.latitudeDelta / 2,
            longitude: region.center.longitude + region.span.longitudeDelta / 2
        )
        
        let topLeftMapPoint = MKMapPoint(topLeft)
        let bottomRightMapPoint = MKMapPoint(bottomRight)
        
        return MKMapRect(
            x: min(topLeftMapPoint.x, bottomRightMapPoint.x),
            y: min(topLeftMapPoint.y, bottomRightMapPoint.y),
            width: abs(bottomRightMapPoint.x - topLeftMapPoint.x),
            height: abs(bottomRightMapPoint.y - topLeftMapPoint.y)
        )
    }
}

// MARK: - Heading Indicator Renderer
class UserHeadingOverlayRenderer: MKOverlayRenderer {
    private let headingOverlay: UserHeadingOverlay
    
    init(overlay: UserHeadingOverlay) {
        self.headingOverlay = overlay
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        print("🖌️ Drawing heading overlay for heading: \(headingOverlay.heading)°")
        
        // Get user location point in view
        let centerPoint = point(for: MKMapPoint(headingOverlay.coordinate))
        print("📍 Center point: \(centerPoint)")
        
        // Set drawing attributes - Use blue
        context.setStrokeColor(UIColor.systemBlue.cgColor)
        context.setFillColor(UIColor.systemBlue.withAlphaComponent(0.7).cgColor)
        context.setLineWidth(2.0)
        
        // Arrow parameters
        let arrowLength: CGFloat = 60.0 // Arrow length
        let arrowWidth: CGFloat = 40.0 // Arrow width
        let headingRadians = CGFloat(headingOverlay.heading) * .pi / 180.0 - .pi / 2 // Convert to radians, adjust coordinate system
        
        // Calculate arrow's three points
        let tipPoint = CGPoint(
            x: centerPoint.x + arrowLength * cos(headingRadians),
            y: centerPoint.y + arrowLength * sin(headingRadians)
        )
        
        let leftPoint = CGPoint(
            x: centerPoint.x + arrowWidth/2 * cos(headingRadians + .pi/2),
            y: centerPoint.y + arrowWidth/2 * sin(headingRadians + .pi/2)
        )
        
        let rightPoint = CGPoint(
            x: centerPoint.x + arrowWidth/2 * cos(headingRadians - .pi/2),
            y: centerPoint.y + arrowWidth/2 * sin(headingRadians - .pi/2)
        )
        
        // Draw arrow
        context.beginPath()
        context.move(to: tipPoint)
        context.addLine(to: leftPoint)
        context.addLine(to: rightPoint)
        context.closePath()
        
        // Fill and stroke
        context.fillPath()
        
        // Add a small dot to represent user location
        let dotRadius: CGFloat = 6.0
        context.setFillColor(UIColor.white.cgColor)
        context.addArc(center: centerPoint, radius: dotRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.fillPath()
        
        context.setStrokeColor(UIColor.systemBlue.cgColor)
        context.addArc(center: centerPoint, radius: dotRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.strokePath()
    }
}

// MARK: - MKPolyline Extension
extension MKPolyline {
    func coordinates() -> [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
} 