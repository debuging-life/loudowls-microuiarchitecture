import Foundation
import Observation

@Observable
final class HomeItemDetailViewModel {

    let item: HomeItem

    var recentTransactions: [Transaction] {
        Transaction.mock(for: item.title)
    }

    init(item: HomeItem) {
        self.item = item
    }
}

// MARK: - Transaction Model

struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Decimal
    let date: Date

    static func mock(for account: String) -> [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        return [
            Transaction(description: "Direct Deposit", amount: 2_500.00, date: calendar.date(byAdding: .day, value: -1, to: now) ?? now),
            Transaction(description: "Grocery Store", amount: -87.43, date: calendar.date(byAdding: .day, value: -2, to: now) ?? now),
            Transaction(description: "Electric Bill", amount: -142.00, date: calendar.date(byAdding: .day, value: -3, to: now) ?? now),
            Transaction(description: "Transfer In", amount: 500.00, date: calendar.date(byAdding: .day, value: -5, to: now) ?? now),
            Transaction(description: "Restaurant", amount: -65.20, date: calendar.date(byAdding: .day, value: -6, to: now) ?? now),
        ]
    }
}
