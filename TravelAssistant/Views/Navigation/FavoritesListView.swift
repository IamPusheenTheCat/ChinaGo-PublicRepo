import SwiftUI
import MapKit

struct FavoritesListView: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    
    var onLocationSelected: (MKMapItem) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favorites.sorted(by: { $0.createdAt > $1.createdAt })) { favorite in
                    Button(action: {
                        onLocationSelected(favorite.mapItem)
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(favorite.name)
                                    .font(.headline)
                                Text(favorite.address)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(favorite.category)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            favoritesManager.removeFavorite(withId: favorite.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Favorites")
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
} 