import SwiftUI
import MicroUICore
import Factory

struct FeatureHomeMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        // Live data source goes through OwlsBaseService.
        // In DEBUG, mocks from the Debug Drawer intercept these calls.
        // In RELEASE, real API is called.
        let dataSource = LiveHomeDataSource()
        let dispatcher = HomeServiceDispatcher(dataSource: dataSource)
        let repository = DefaultHomeRepository(dispatcher: dispatcher)
        let viewModel = HomeListViewModel(repository: repository)
        return AnyView(HomeListView(viewModel: viewModel))
    }
}
