import SwiftUI
import MapKit

struct FavoriteRoutesListView: View {
    @ObservedObject var favoriteRoutesManager: FavoriteRoutesManager
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    
    var onRouteSelected: (FavoriteRoute) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteRoutesManager.favoriteRoutes.sorted(by: { $0.createdAt > $1.createdAt })) { route in
                    Button(action: {
                        onRouteSelected(route)
                        dismiss()
                    }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(route.name)
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                                    .font(.caption2)
                                Text(route.originName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption2)
                                Text(route.destinationName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Image(systemName: transportTypeIcon(for: route.transportType))
                                    .font(.caption)
                                Text(route.transportType.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            favoriteRoutesManager.removeFavoriteRoute(withId: route.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Favorite Routes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func transportTypeIcon(for type: String) -> String {
        switch type.lowercased() {
        case "driving":
            return "car.fill"
        case "walking":
            return "figure.walk"
        case "transit":
            return "bus.fill"
        default:
            return "location.fill"
        }
    }
} 