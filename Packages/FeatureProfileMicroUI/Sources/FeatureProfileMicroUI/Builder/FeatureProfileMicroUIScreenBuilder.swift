import SwiftUI
import MicroUICore
import Factory

struct FeatureProfileMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockProfileDataSource()
        let dispatcher = ProfileServiceDispatcher(dataSource: dataSource)
        let repository = DefaultProfileRepository(dispatcher: dispatcher)
        let viewModel = ProfileViewModel(repository: repository)
        return AnyView(ProfileView(viewModel: viewModel))
    }
}
