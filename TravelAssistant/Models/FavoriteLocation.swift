//
//  FavoriteLocation.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation
import MapKit
import CoreLocation

struct FavoriteLocation: Identifiable, Codable {
    let id: UUID
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let category: String
    let createdAt: Date
    
    init(id: UUID = UUID(), name: String, address: String, coordinate: CLLocationCoordinate2D, category: String = "其他", createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.category = category
        self.createdAt = createdAt
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = name
        return item
    }
}

// 新增：历史地点数据模型
struct HistoryLocation: Identifiable, Codable {
    let id: UUID
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let visitedAt: Date
    let visitCount: Int
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.visitedAt = Date()
        self.visitCount = 1
    }
    
    // 更新访问次数和时间
    func updatedVisit() -> HistoryLocation {
        return HistoryLocation(
            id: self.id,
            name: self.name,
            address: self.address,
            coordinate: self.coordinate,
            visitedAt: Date(),
            visitCount: self.visitCount + 1
        )
    }
    
    // 私有初始化方法，用于创建更新的实例
    private init(id: UUID, name: String, address: String, coordinate: CLLocationCoordinate2D, visitedAt: Date, visitCount: Int) {
        self.id = id
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.visitedAt = visitedAt
        self.visitCount = visitCount
    }
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}

// 收藏夹管理器
class FavoritesManager: ObservableObject {
    @Published var favorites: [FavoriteLocation] = []
    private let saveKey = "FavoriteLocations"
    
    init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([FavoriteLocation].self, from: data) {
            favorites = decoded
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addFavorite(_ location: FavoriteLocation) {
        favorites.append(location)
        saveFavorites()
    }
    
    func removeFavorite(withId id: UUID) {
        favorites.removeAll { $0.id == id }
        saveFavorites()
    }
    
    func isFavorite(coordinate: CLLocationCoordinate2D) -> Bool {
        favorites.contains { favorite in
            abs(favorite.latitude - coordinate.latitude) < 0.0001 &&
            abs(favorite.longitude - coordinate.longitude) < 0.0001
        }
    }
    
    func getFavorite(coordinate: CLLocationCoordinate2D) -> FavoriteLocation? {
        favorites.first { favorite in
            abs(favorite.latitude - coordinate.latitude) < 0.0001 &&
            abs(favorite.longitude - coordinate.longitude) < 0.0001
        }
    }
}

// 历史地点管理器
class HistoryLocationManager: ObservableObject {
    @Published var historyLocations: [HistoryLocation] = []
    private let userDefaults = UserDefaults.standard
    private let historyKey = "history_locations"
    
    init() {
        loadHistoryLocations()
    }
    
    // 添加历史地点（智能去重）
    func addHistoryLocation(name: String, address: String, coordinate: CLLocationCoordinate2D) {
        // 检查是否已存在相同地点（基于坐标位置，50米范围内视为同一地点）
        if let existingIndex = historyLocations.firstIndex(where: { location in
            let distance = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                .distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            return distance < 50 // 50米内视为同一地点
        }) {
            // 更新现有地点的访问信息
            historyLocations[existingIndex] = historyLocations[existingIndex].updatedVisit()
        } else {
            // 添加新地点
            let newLocation = HistoryLocation(name: name, address: address, coordinate: coordinate)
            historyLocations.insert(newLocation, at: 0) // 插入到最前面
            
            // 限制历史记录数量（最多保存100个）
            if historyLocations.count > 100 {
                historyLocations = Array(historyLocations.prefix(100))
            }
        }
        
        saveHistoryLocations()
    }
    
    // 删除历史地点
    func removeHistoryLocation(at indexSet: IndexSet) {
        historyLocations.remove(atOffsets: indexSet)
        saveHistoryLocations()
    }
    
    // 清空历史记录
    func clearHistory() {
        historyLocations.removeAll()
        saveHistoryLocations()
    }
    
    // 保存到本地存储
    private func saveHistoryLocations() {
        if let encoded = try? JSONEncoder().encode(historyLocations) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    // 从本地存储加载
    private func loadHistoryLocations() {
        if let data = userDefaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([HistoryLocation].self, from: data) {
            historyLocations = decoded
        }
    }
    
    // 获取最近访问的地点
    func getRecentLocations(limit: Int = 10) -> [HistoryLocation] {
        return Array(historyLocations.prefix(limit))
    }
    
    // 获取最常访问的地点
    func getFrequentLocations(limit: Int = 10) -> [HistoryLocation] {
        return historyLocations.sorted { $0.visitCount > $1.visitCount }.prefix(limit).map { $0 }
    }
} 