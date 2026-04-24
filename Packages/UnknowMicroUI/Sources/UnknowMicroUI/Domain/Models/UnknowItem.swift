import Foundation

struct UnknowItem: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let createdAt: Date

    static let mock: [UnknowItem] = [
        UnknowItem(id: "1", title: "Sample Unknow 1", subtitle: "Description for item 1", iconName: "star.fill", createdAt: Date()),
        UnknowItem(id: "2", title: "Sample Unknow 2", subtitle: "Description for item 2", iconName: "heart.fill", createdAt: Date()),
        UnknowItem(id: "3", title: "Sample Unknow 3", subtitle: "Description for item 3", iconName: "bolt.fill", createdAt: Date()),
    ]
}