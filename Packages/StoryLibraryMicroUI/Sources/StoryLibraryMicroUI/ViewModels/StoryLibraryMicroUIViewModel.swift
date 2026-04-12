import Foundation
import Observation

@Observable
final class StoryLibraryMicroUIViewModel {

    private(set) var items: [StoryLibraryItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let repository: StoryLibraryRepository

    init(repository: StoryLibraryRepository) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await repository.loadAll()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func deleteItem(id: String) async {
        do {
            try await repository.delete(id: id)
            items.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
