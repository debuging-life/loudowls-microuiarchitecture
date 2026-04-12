import SwiftUI
import MicroUICore
import Factory

struct AboutScreenMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockAboutScreenDataSource()
        let dispatcher = AboutScreenServiceDispatcher(dataSource: dataSource)
        let repository = DefaultAboutScreenRepository(dispatcher: dispatcher)
        let viewModel = AboutScreenMicroUIViewModel(repository: repository)
        return AnyView(AboutScreenMicroUIView(viewModel: viewModel))
    }
}
