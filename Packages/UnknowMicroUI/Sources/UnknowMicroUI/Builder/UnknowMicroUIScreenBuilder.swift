import SwiftUI
import MicroUICore
import Factory

struct UnknowMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockUnknowDataSource()
        let dispatcher = UnknowServiceDispatcher(dataSource: dataSource)
        let repository = DefaultUnknowRepository(dispatcher: dispatcher)
        let viewModel = UnknowMicroUIViewModel(repository: repository)
        return AnyView(UnknowMicroUIView(viewModel: viewModel))
    }
}