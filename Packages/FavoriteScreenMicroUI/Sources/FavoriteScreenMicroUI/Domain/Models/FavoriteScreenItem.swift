import Foundation

struct FavoriteScreenItem: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let createdAt: Date

    static let mock: [FavoriteScreenItem] = [
        FavoriteScreenItem(id: "1", title: "Sample FavoriteScreen 1", subtitle: "Description for item 1", iconName: "star.fill", createdAt: Date()),
        FavoriteScreenItem(id: "2", title: "Sample FavoriteScreen 2", subtitle: "Description for item 2", iconName: "heart.fill", createdAt: Date()),
        FavoriteScreenItem(id: "3", title: "Sample FavoriteScreen 3", subtitle: "Description for item 3", iconName: "bolt.fill", createdAt: Date()),
    ]
}