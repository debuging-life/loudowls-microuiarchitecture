import SwiftUI
import MicroUICore
import Factory

struct OwlScreenMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockOwlScreenDataSource()
        let dispatcher = OwlScreenServiceDispatcher(dataSource: dataSource)
        let repository = DefaultOwlScreenRepository(dispatcher: dispatcher)
        let viewModel = OwlScreenMicroUIViewModel(repository: repository)
        return AnyView(OwlScreenMicroUIView(viewModel: viewModel))
    }
}