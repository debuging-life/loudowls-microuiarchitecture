import SwiftUI
import MicroUICore

enum FeatureProfileMicroUIRouter: OwlsRouter {

    case editProfile(UserProfile)

    // MARK: - Identifiable

    var id: String {
        switch self {
        case .editProfile(let profile): "profile-edit-\(profile.id)"
        }
    }

    // MARK: - Route Resolution

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .editProfile(let profile):
            let dataSource = MockProfileDataSource()
            let dispatcher = ProfileServiceDispatcher(dataSource: dataSource)
            let repository = DefaultProfileRepository(dispatcher: dispatcher)
            EditProfileView(profile: profile, repository: repository)
        }
    }
}
