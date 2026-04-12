import SwiftUI
import MicroUICore
import Factory

struct AuthMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockAuthDataSource()
        let dispatcher = AuthServiceDispatcher(dataSource: dataSource)
        let repository = DefaultAuthRepository(dispatcher: dispatcher)
        let viewModel = AuthMicroUIViewModel(repository: repository)
        return AnyView(AuthMicroUIView(viewModel: viewModel))
    }
}
