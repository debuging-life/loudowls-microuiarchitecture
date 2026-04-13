import Foundation
import Observation
import MicroUICore

@Observable
final class HomeListViewModel {

    let paginator: OwlsPaginator<Story>
    var isCreateSheetPresented = false
    private(set) var errorMessage: String?

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
        self.paginator = OwlsPaginator(pageSize: 10) { page, size in
            try await repository.loadStories(page: page, limit: size)
        }
    }

    // MARK: - Create

    func createStory(title: String, author: String, summary: String) async {
        do {
            let newStory = try await repository.createStory(title: title, author: author, summary: summary)
            paginator.insert(newStory, at: 0)
            isCreateSheetPresented = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Delete

    func deleteStory(id: String) async {
        do {
            try await repository.deleteStory(id: id)
            paginator.remove { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Toggle Favorite

    func toggleFavorite(id: String) {
        if let index = paginator.items.firstIndex(where: { $0.id == id }) {
            paginator.items[index].isFavorite.toggle()
        }
    }
}
