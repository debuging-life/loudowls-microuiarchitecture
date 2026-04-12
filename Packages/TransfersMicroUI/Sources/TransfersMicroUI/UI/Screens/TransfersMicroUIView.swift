import SwiftUI
import MicroUICore

struct TransfersMicroUIView: View {

    @State private var viewModel: TransfersMicroUIViewModel
    @Injected(\.transfersNavigationCoordinator) private var coordinator

    init(viewModel: TransfersMicroUIViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Something went wrong",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else {
                    List(viewModel.items, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .navigationTitle("Transfers")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { coordinator.dismiss() }
                }
            }
        }
        .task { await viewModel.load() }
    }
}
