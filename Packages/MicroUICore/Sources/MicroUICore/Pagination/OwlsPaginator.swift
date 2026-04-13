import Foundation
import Observation

// MARK: - Page State

public enum OwlsPageState: Sendable, Equatable {
    case idle
    case loading
    case loadingMore
    case loaded
    case empty
    case error(String)
}

// MARK: - Paginator

@Observable
public final class OwlsPaginator<Item: Identifiable & Sendable> {

    public var items: [Item] = []
    public private(set) var state: OwlsPageState = .idle
    public private(set) var currentPage = 1
    public private(set) var hasMorePages = true

    private let pageSize: Int
    private let fetchPage: (Int, Int) async throws -> [Item]

    public init(
        pageSize: Int = 20,
        fetchPage: @escaping (Int, Int) async throws -> [Item]
    ) {
        self.pageSize = pageSize
        self.fetchPage = fetchPage
    }

    // MARK: - Load First Page

    public func loadFirstPage() async {
        guard state != .loading else { return }

        state = .loading
        currentPage = 1
        hasMorePages = true

        do {
            let newItems = try await fetchPage(currentPage, pageSize)
            items = newItems
            hasMorePages = newItems.count >= pageSize
            state = newItems.isEmpty ? .empty : .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Load Next Page

    public func loadNextPageIfNeeded(currentItem: Item) async {
        guard hasMorePages, state != .loadingMore else { return }

        // Trigger when reaching last 3 items
        let thresholdIndex = items.index(items.endIndex, offsetBy: -3, limitedBy: items.startIndex) ?? items.startIndex
        guard let itemIndex = items.firstIndex(where: { $0.id == currentItem.id }),
              itemIndex >= thresholdIndex else { return }

        await loadNextPage()
    }

    // MARK: - Load Next Page (direct)

    public func loadNextPage() async {
        guard hasMorePages, state != .loadingMore else { return }

        state = .loadingMore
        currentPage += 1

        do {
            let newItems = try await fetchPage(currentPage, pageSize)
            items.append(contentsOf: newItems)
            hasMorePages = newItems.count >= pageSize
            state = .loaded
        } catch {
            currentPage -= 1
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Refresh

    public func refresh() async {
        await loadFirstPage()
    }

    // MARK: - Insert / Remove

    public func insert(_ item: Item, at index: Int = 0) {
        items.insert(item, at: index)
    }

    public func remove(where predicate: (Item) -> Bool) {
        items.removeAll(where: predicate)
    }
}
