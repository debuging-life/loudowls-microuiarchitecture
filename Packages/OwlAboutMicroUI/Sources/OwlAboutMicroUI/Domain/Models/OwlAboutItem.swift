import Foundation

struct OwlAboutItem: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let createdAt: Date

    static let mock: [OwlAboutItem] = [
        OwlAboutItem(id: "1", title: "Sample OwlAbout 1", subtitle: "Description for item 1", iconName: "star.fill", createdAt: Date()),
        OwlAboutItem(id: "2", title: "Sample OwlAbout 2", subtitle: "Description for item 2", iconName: "heart.fill", createdAt: Date()),
        OwlAboutItem(id: "3", title: "Sample OwlAbout 3", subtitle: "Description for item 3", iconName: "bolt.fill", createdAt: Date()),
    ]
}