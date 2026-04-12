import SwiftUI
import MicroUICore

struct AboutScreenMicroUIView: View {

    @State private var viewModel: AboutScreenMicroUIViewModel

    init(viewModel: AboutScreenMicroUIViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.items, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .navigationTitle("AboutScreen")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        // TODO: inject coordinator and call dismiss()
                    }
                }
            }
        }
        .task { await viewModel.load() }
    }
}
