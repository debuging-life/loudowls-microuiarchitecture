import SwiftUI
import MicroUICore
import Factory

struct FavoriteScreenMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockFavoriteScreenDataSource()
        let dispatcher = FavoriteScreenServiceDispatcher(dataSource: dataSource)
        let repository = DefaultFavoriteScreenRepository(dispatcher: dispatcher)
        let viewModel = FavoriteScreenMicroUIViewModel(repository: repository)
        return AnyView(FavoriteScreenMicroUIView(viewModel: viewModel))
    }
}