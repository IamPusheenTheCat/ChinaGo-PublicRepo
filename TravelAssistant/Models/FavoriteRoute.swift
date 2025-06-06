import Foundation
import MapKit
import CoreLocation

struct FavoriteRoute: Identifiable, Codable {
    let id: UUID
    let name: String
    let originName: String
    let destinationName: String
    let originLatitude: Double
    let originLongitude: Double
    let destinationLatitude: Double
    let destinationLongitude: Double
    let transportType: String
    let createdAt: Date
    
    init(id: UUID = UUID(), 
         name: String,
         originName: String,
         destinationName: String,
         origin: CLLocationCoordinate2D,
         destination: CLLocationCoordinate2D,
         transportType: String = "driving",
         createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.originName = originName
        self.destinationName = destinationName
        self.originLatitude = origin.latitude
        self.originLongitude = origin.longitude
        self.destinationLatitude = destination.latitude
        self.destinationLongitude = destination.longitude
        self.transportType = transportType
        self.createdAt = createdAt
    }
    
    var originCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude)
    }
    
    var destinationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
    }
}

class FavoriteRoutesManager: ObservableObject {
    @Published var favoriteRoutes: [FavoriteRoute] = []
    private let saveKey = "FavoriteRoutes"
    
    init() {
        loadFavoriteRoutes()
    }
    
    private func loadFavoriteRoutes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([FavoriteRoute].self, from: data) {
            favoriteRoutes = decoded
        }
    }
    
    private func saveFavoriteRoutes() {
        if let encoded = try? JSONEncoder().encode(favoriteRoutes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addFavoriteRoute(_ route: FavoriteRoute) {
        favoriteRoutes.append(route)
        saveFavoriteRoutes()
    }
    
    func removeFavoriteRoute(withId id: UUID) {
        favoriteRoutes.removeAll { $0.id == id }
        saveFavoriteRoutes()
    }
} 