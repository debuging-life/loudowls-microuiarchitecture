import SwiftUI
import MicroUICore
import Factory

struct FeatureHomeMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockHomeDataSource()
        let dispatcher = HomeServiceDispatcher(dataSource: dataSource)
        let repository = DefaultHomeRepository(dispatcher: dispatcher)
        let viewModel = HomeListViewModel(repository: repository)
        return AnyView(HomeListView(viewModel: viewModel))
    }
}
