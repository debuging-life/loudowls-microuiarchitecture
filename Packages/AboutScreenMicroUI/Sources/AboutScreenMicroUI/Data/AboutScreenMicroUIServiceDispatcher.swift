import Foundation

struct AboutScreenServiceDispatcher: Sendable {
    let dataSource: AboutScreenDataSource

    func getData() async throws -> [String] {
        try await dataSource.fetchData()
    }
}
