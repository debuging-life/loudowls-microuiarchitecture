import Foundation

protocol TransfersDataSource: Sendable {
    func fetchData() async throws -> [String]
}

struct MockTransfersDataSource: TransfersDataSource {
    func fetchData() async throws -> [String] {
        try await Task.sleep(for: .milliseconds(300))
        return ["Item 1", "Item 2", "Item 3"]
    }
}
