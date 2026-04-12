import Foundation

protocol AboutScreenDataSource: Sendable {
    func fetchData() async throws -> [String]
}

struct MockAboutScreenDataSource: AboutScreenDataSource {
    func fetchData() async throws -> [String] {
        try await Task.sleep(for: .milliseconds(300))
        return ["Item 1", "Item 2", "Item 3"]
    }
}
