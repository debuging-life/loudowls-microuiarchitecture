import Foundation

struct HomeItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let iconName: String
    let amount: Decimal?

    static let mock: [HomeItem] = [
        HomeItem(id: UUID(), title: "Checking Account", subtitle: "••••4523", iconName: "banknote", amount: 3_245.67),
        HomeItem(id: UUID(), title: "Savings Account", subtitle: "••••8891", iconName: "leaf", amount: 12_580.00),
        HomeItem(id: UUID(), title: "Credit Card", subtitle: "••••7712", iconName: "creditcard", amount: -1_432.50),
        HomeItem(id: UUID(), title: "Auto Loan", subtitle: "••••3301", iconName: "car", amount: -18_200.00),
        HomeItem(id: UUID(), title: "Investment", subtitle: "Brokerage", iconName: "chart.line.uptrend.xyaxis", amount: 45_890.12),
    ]
}
