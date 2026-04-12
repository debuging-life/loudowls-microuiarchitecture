import Foundation

struct StoryLibraryItem: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let createdAt: Date

    static let mock: [StoryLibraryItem] = [
        StoryLibraryItem(id: "1", title: "Sample StoryLibrary 1", subtitle: "Description for item 1", iconName: "star.fill", createdAt: Date()),
        StoryLibraryItem(id: "2", title: "Sample StoryLibrary 2", subtitle: "Description for item 2", iconName: "heart.fill", createdAt: Date()),
        StoryLibraryItem(id: "3", title: "Sample StoryLibrary 3", subtitle: "Description for item 3", iconName: "bolt.fill", createdAt: Date()),
    ]
}
