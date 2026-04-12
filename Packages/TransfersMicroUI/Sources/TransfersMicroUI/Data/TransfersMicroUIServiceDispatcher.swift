import Foundation

struct TransfersServiceDispatcher: Sendable {
    let dataSource: TransfersDataSource

    func getData() async throws -> [String] {
        try await dataSource.fetchData()
    }
}
