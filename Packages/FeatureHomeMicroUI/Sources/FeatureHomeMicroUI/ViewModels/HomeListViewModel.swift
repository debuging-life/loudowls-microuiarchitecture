import Foundation
import Observation

@Observable
final class HomeListViewModel {

    // MARK: - State

    private(set) var items: [HomeItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    // MARK: - Actions

    func loadItems() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await repository.loadItems()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
