import Foundation
import Observation

@Observable
final class HomeListViewModel {

    private(set) var stories: [Story] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var isCreateSheetPresented = false

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func loadStories() async {
        isLoading = true
        errorMessage = nil
        do {
            stories = try await repository.loadStories()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func createStory(title: String, author: String, summary: String) async {
        do {
            let newStory = try await repository.createStory(title: title, author: author, summary: summary)
            stories.insert(newStory, at: 0)
            isCreateSheetPresented = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteStory(id: String) async {
        do {
            try await repository.deleteStory(id: id)
            stories.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite(id: String) {
        if let index = stories.firstIndex(where: { $0.id == id }) {
            stories[index].isFavorite.toggle()
        }
    }
}
