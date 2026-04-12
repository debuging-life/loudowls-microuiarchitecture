import SwiftUI
import MicroUICore

struct StoryLibraryMicroUIView: View {

    @State private var viewModel: StoryLibraryMicroUIViewModel
    @Injected(\.storylibraryNavigationCoordinator) private var coordinator
    @State private var path = NavigationPath()

    init(viewModel: StoryLibraryMicroUIViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if viewModel.isLoading {
                    OwlsLoadingView("Loading storylibrary…")
                } else if let error = viewModel.errorMessage {
                    OwlsEmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Something went wrong",
                        description: error,
                        actionTitle: "Retry"
                    ) { Task { await viewModel.load() } }
                } else if viewModel.items.isEmpty {
                    OwlsEmptyState(
                        icon: "tray",
                        title: "No StoryLibrary Yet",
                        description: "Items will appear here once available."
                    )
                } else {
                    itemList
                }
            }
            .navigationTitle("StoryLibrary")
            .navigationDestination(for: StoryLibraryMicroUIRouter.self) { route in
                route.resolveViewForRoute()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { coordinator.dismiss() }
                }
            }
        }
        .task { await viewModel.load() }
    }

    private var itemList: some View {
        List {
            ForEach(viewModel.items) { item in
                Button {
                    path.append(StoryLibraryMicroUIRouter.detail(item))
                } label: {
                    HStack(spacing: OwlsSpacing.md) {
                        Image(systemName: item.iconName)
                            .font(.title3)
                            .foregroundStyle(OwlsColor.primary)
                            .frame(width: 36, height: 36)

                        VStack(alignment: .leading, spacing: OwlsSpacing.xxs) {
                            Text(item.title)
                                .font(OwlsTypography.headline)
                            Text(item.subtitle)
                                .font(OwlsTypography.caption)
                                .foregroundStyle(OwlsColor.secondaryLabel)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(OwlsColor.secondaryLabel)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let item = viewModel.items[index]
                    Task { await viewModel.deleteItem(id: item.id) }
                }
            }
        }
        .listStyle(.plain)
    }
}
