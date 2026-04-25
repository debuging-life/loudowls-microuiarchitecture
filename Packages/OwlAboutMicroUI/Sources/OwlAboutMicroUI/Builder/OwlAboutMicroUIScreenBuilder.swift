import SwiftUI
import MicroUICore
import Factory

struct OwlAboutMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockOwlAboutDataSource()
        let dispatcher = OwlAboutServiceDispatcher(dataSource: dataSource)
        let repository = DefaultOwlAboutRepository(dispatcher: dispatcher)
        let viewModel = OwlAboutMicroUIViewModel(repository: repository)
        return AnyView(OwlAboutMicroUIView(viewModel: viewModel))
    }
}