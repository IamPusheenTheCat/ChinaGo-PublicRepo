//
//  DestinationPickerView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI
import MapKit

struct DestinationPickerView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var recentSearches: [String] = []
    @State private var popularDestinations: [PopularDestination] = []
    @State private var selectedDestination: MKMapItem?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                searchBar
                
                // 内容区域
                ScrollView {
                    VStack(spacing: 20) {
                        // 搜索结果
                        if !mapViewModel.searchResults.isEmpty {
                            searchResultsSection
                        } else if searchText.isEmpty {
                            // 最近搜索和热门目的地
                            if !recentSearches.isEmpty {
                                recentSearchesSection
                            }
                            
                            popularDestinationsSection
                        } else {
                            // 无搜索结果
                            emptyResultsView
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Choose your destination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    // MARK: - 视图组件
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search for a location or address", text: $searchText)
                .onSubmit {
                    searchDestination()
                }
                .onChange(of: searchText) { _, newValue in
                    if newValue.isEmpty {
                        mapViewModel.searchResults = []
                    }
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    mapViewModel.searchResults = []
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Search Results")
                .font(.headline)
                .padding(.bottom, 10)
            
            ForEach(mapViewModel.searchResults.indices, id: \.self) { index in
                let mapItem = mapViewModel.searchResults[index]
                
                DestinationRow(
                    title: mapItem.name ?? "Unknown Location",
                    subtitle: mapItem.placemark.title ?? "",
                    icon: "location.circle.fill"
                ) {
                    selectDestination(mapItem)
                }
                
                if index < mapViewModel.searchResults.count - 1 {
                    Divider()
                        .padding(.leading, 50)
                }
            }
        }
    }
    
    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    recentSearches.removeAll()
                    saveRecentSearches()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.bottom, 10)
            
            ForEach(recentSearches.indices, id: \.self) { index in
                let search = recentSearches[index]
                
                DestinationRow(
                    title: search,
                    subtitle: "Recent Searches",
                    icon: "clock.arrow.circlepath"
                ) {
                    searchText = search
                    searchDestination()
                }
                
                if index < recentSearches.count - 1 {
                    Divider()
                        .padding(.leading, 50)
                }
            }
        }
    }
    
    private var popularDestinationsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Popular Destinations")
                .font(.headline)
                .padding(.bottom, 10)
            
            ForEach(popularDestinations.indices, id: \.self) { index in
                let destination = popularDestinations[index]
                
                DestinationRow(
                    title: destination.name,
                    subtitle: destination.description,
                    icon: destination.icon
                ) {
                    searchText = destination.name
                    searchDestination()
                }
                
                if index < popularDestinations.count - 1 {
                    Divider()
                        .padding(.leading, 50)
                }
            }
        }
    }
    
    private var emptyResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No related locations found")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Please try another search term")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }
    
    // MARK: - 功能方法
    
    private func searchDestination() {
        guard !searchText.isEmpty else { return }
        
        mapViewModel.searchLocation(searchText)
        addToRecentSearches(searchText)
    }
    
    private func selectDestination(_ mapItem: MKMapItem) {
        selectedDestination = mapItem
        mapViewModel.selectDestination(coordinate: mapItem.placemark.coordinate, title: mapItem.name ?? "Destination")
        dismiss()
    }
    
    private func addToRecentSearches(_ search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }
        
        recentSearches.insert(search, at: 0)
        
        // 限制最近搜索的数量
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
        
        saveRecentSearches()
    }
    
    private func loadData() {
        loadRecentSearches()
        loadPopularDestinations()
    }
    
    private func loadRecentSearches() {
        if let data = UserDefaults.standard.data(forKey: "RecentSearches"),
           let searches = try? JSONDecoder().decode([String].self, from: data) {
            recentSearches = searches
        }
    }
    
    private func saveRecentSearches() {
        if let data = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(data, forKey: "RecentSearches")
        }
    }
    
    private func loadPopularDestinations() {
        popularDestinations = [
            PopularDestination(name: "The Forbidden City", description: "Beijing·World Heritage Site", icon: "building.columns.fill"),
            PopularDestination(name: "The Bund", description: "Shanghai·Famous Attractions", icon: "water.waves"),
            PopularDestination(name: "Lu Jia Zui", description: "Shanghai·Financial Center", icon: "building.2.fill"),
            PopularDestination(name: "West Lake", description: "Hangzhou·Natural Scenery", icon: "drop.fill"),
            PopularDestination(name: "Guangzhou Tower", description: "Guangzhou·Landmark Building", icon: "antenna.radiowaves.left.and.right"),
            PopularDestination(name: "Shenzhen Bay Park", description: "Shenzhen·Beach Park", icon: "tree.fill"),
            PopularDestination(name: "Tianjin Eye", description: "Tianjin·Ferris Wheel", icon: "circle.fill")
        ]
    }
}

// MARK: - 目的地行视图
struct DestinationRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 数据模型
struct PopularDestination {
    let name: String
    let description: String
    let icon: String
}

struct DestinationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationPickerView(mapViewModel: MapViewModel())
    }
} 