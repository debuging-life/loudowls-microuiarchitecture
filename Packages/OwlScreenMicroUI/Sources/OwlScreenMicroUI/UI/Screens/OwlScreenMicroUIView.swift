import SwiftUI
import MicroUICore

// MARK: - Main Screen (presented as fullScreenCover from dashboard)

struct OwlScreenMicroUIView: View {

    @State private var viewModel: OwlScreenMicroUIViewModel
    @Injected(\.owlscreenNavigationCoordinator) private var coordinator
    @State private var path = NavigationPath()

    init(viewModel: OwlScreenMicroUIViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if viewModel.isLoading {
                    OwlsLoadingView("Loading owlscreen…")
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
                        title: "No OwlScreen Yet",
                        description: "Items will appear here once available."
                    )
                } else {
                    itemList
                }
            }
            .navigationTitle("OwlScreen")
            // MARK: Navigation — push to detail screen
            .navigationDestination(for: OwlScreenMicroUIRouter.self) { route in
                route.resolveViewForRoute()
            }
            .toolbar {
                // MARK: Dismiss — closes fullScreenCover
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { coordinator.dismiss() }
                }
                // MARK: Sheet — opens create form as sheet
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isCreateSheetPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // MARK: Sheet presentation
            .sheet(isPresented: $viewModel.isCreateSheetPresented) {
                OwlScreenCreateSheet(viewModel: viewModel)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .task { await viewModel.load() }
    }

    // MARK: - List (tapping a row pushes detail screen)

    private var itemList: some View {
        List {
            ForEach(viewModel.items) { item in
                Button {
                    // Navigation: push detail screen
                    path.append(OwlScreenMicroUIRouter.detail(item))
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