import Foundation
import Observation

@Observable
final class TransfersMicroUIViewModel {

    private(set) var items: [String] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let repository: TransfersRepository

    init(repository: TransfersRepository) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await repository.loadData()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
