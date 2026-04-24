import Foundation
import Observation

@Observable
final class UnknowMicroUIViewModel {

    private(set) var items: [UnknowItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var isCreateSheetPresented = false

    private let repository: UnknowRepository

    init(repository: UnknowRepository) {
        self.repository = repository
    }

    // MARK: - Load

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

    // MARK: - Create

    func createItem(name: String) async {
        do {
            let newItem = try await repository.create(name: name)
            items.insert(newItem, at: 0)
            isCreateSheetPresented = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Delete

    func deleteItem(id: String) async {
        do {
            try await repository.delete(id: id)
            items.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}