import Foundation

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var avatarInitials: String { "\(firstName.prefix(1))\(lastName.prefix(1))" }

    static let mock = UserProfile(
        id: UUID(),
        firstName: "Pardip",
        lastName: "Bhatti",
        email: "pardip@example.com",
        phone: "+1 (555) 012-3456"
    )
}
