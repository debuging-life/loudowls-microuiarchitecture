import SwiftUI
import MicroUICore
import Factory

struct TransfersMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockTransfersDataSource()
        let dispatcher = TransfersServiceDispatcher(dataSource: dataSource)
        let repository = DefaultTransfersRepository(dispatcher: dispatcher)
        let viewModel = TransfersMicroUIViewModel(repository: repository)
        return AnyView(TransfersMicroUIView(viewModel: viewModel))
    }
}
