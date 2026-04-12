import SwiftUI
import MicroUICore

struct HomeListView: View {

    @State private var viewModel: HomeListViewModel
    @State private var path = NavigationPath()

    init(viewModel: HomeListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Accounts")
                .navigationDestination(for: FeatureHomeMicroUIRouter.self) { route in
                    route.resolveViewForRoute()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        dismissButton
                    }
                }
        }
        .task { await viewModel.loadItems() }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading accounts…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(error)
            )
        } else {
            list
        }
    }

    private var list: some View {
        List(viewModel.items) { item in
            Button {
                path.append(FeatureHomeMicroUIRouter.detail(item))
            } label: {
                HomeItemRow(item: item)
            }
        }
        .listStyle(.plain)
    }

    // MARK: - Dismiss

    @Injected(\.homeNavigationCoordinator) private var coordinator

    private var dismissButton: some View {
        Button("Close") { coordinator.dismiss() }
    }
}

// MARK: - Row

private struct HomeItemRow: View {
    let item: HomeItem

    var body: some View {
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

            if let amount = item.amount {
                Text(amount, format: .currency(code: "USD"))
                    .font(OwlsTypography.callout)
                    .foregroundStyle(amount >= 0 ? OwlsColor.label : .red)
            }
        }
        .padding(.vertical, OwlsSpacing.xs)
    }
}
