import SwiftUI

// MARK: - Paginated List View

public struct OwlsPaginatedList<Item: Identifiable & Sendable, Row: View>: View {

    private let paginator: OwlsPaginator<Item>
    private let row: (Item) -> Row

    public init(
        paginator: OwlsPaginator<Item>,
        @ViewBuilder row: @escaping (Item) -> Row
    ) {
        self.paginator = paginator
        self.row = row
    }

    public var body: some View {
        Group {
            switch paginator.state {
            case .loading:
                OwlsLoadingView()

            case .empty:
                OwlsEmptyState(
                    icon: "tray",
                    title: "Nothing Here",
                    description: "No items found."
                )

            case .error(let message):
                OwlsEmptyState(
                    icon: "exclamationmark.triangle",
                    title: "Something went wrong",
                    description: message,
                    actionTitle: "Retry"
                ) { Task { await paginator.refresh() } }

            default:
                list
            }
        }
        .task {
            if paginator.state == .idle {
                await paginator.loadFirstPage()
            }
        }
        .refreshable {
            await paginator.refresh()
        }
    }

    // MARK: - List

    private var list: some View {
        List {
            ForEach(paginator.items) { item in
                row(item)
                    .task {
                        await paginator.loadNextPageIfNeeded(currentItem: item)
                    }
            }

            // Loading more indicator
            if paginator.state == .loadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
    }
}
