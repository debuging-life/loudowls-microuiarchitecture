import Foundation

struct OwlScreenItem: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let createdAt: Date

    static let mock: [OwlScreenItem] = [
        OwlScreenItem(id: "1", title: "Sample OwlScreen 1", subtitle: "Description for item 1", iconName: "star.fill", createdAt: Date()),
        OwlScreenItem(id: "2", title: "Sample OwlScreen 2", subtitle: "Description for item 2", iconName: "heart.fill", createdAt: Date()),
        OwlScreenItem(id: "3", title: "Sample OwlScreen 3", subtitle: "Description for item 3", iconName: "bolt.fill", createdAt: Date()),
    ]
}