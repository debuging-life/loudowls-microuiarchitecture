import Foundation

struct Story: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let author: String
    let summary: String
    let coverIcon: String
    let readTime: Int
    var isFavorite: Bool

    static let mock: [Story] = [
        Story(id: "1", title: "The Wise Owl", author: "Luna Woods", summary: "A young owl discovers that true wisdom comes not from knowing all the answers, but from asking the right questions. Join Ollie on a moonlit adventure through the enchanted forest.", coverIcon: "bird.fill", readTime: 5, isFavorite: true),
        Story(id: "2", title: "The Star Collector", author: "Mira Sky", summary: "Every night, little Stella climbs the tallest hill to collect fallen stars. But one night, she finds a star that doesn't want to be collected.", coverIcon: "star.fill", readTime: 7, isFavorite: false),
        Story(id: "3", title: "The Brave Little Cloud", author: "Aiden Rain", summary: "Nimbus is the smallest cloud in the sky, but when a drought threatens the village below, only Nimbus is brave enough to make the journey.", coverIcon: "cloud.fill", readTime: 4, isFavorite: true),
        Story(id: "4", title: "The Magic Garden", author: "Flora Green", summary: "When Maya plants a mysterious seed, she discovers a garden where flowers can talk, trees can walk, and every plant has a story to tell.", coverIcon: "leaf.fill", readTime: 6, isFavorite: false),
        Story(id: "5", title: "The Moonlight Express", author: "Kai Night", summary: "A magical train that only appears at midnight takes children on adventures through dreamland. Tonight, it's your turn to board.", coverIcon: "moon.fill", readTime: 8, isFavorite: false),
        Story(id: "6", title: "The Color Thief", author: "Iris Paint", summary: "Someone is stealing all the colors from Rainbow Valley! Can you help detective Violet solve the mystery before everything turns grey?", coverIcon: "paintpalette.fill", readTime: 5, isFavorite: true),
    ]
}
