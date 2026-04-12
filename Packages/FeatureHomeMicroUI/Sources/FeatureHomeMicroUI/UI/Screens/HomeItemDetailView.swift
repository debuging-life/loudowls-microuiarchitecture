import SwiftUI
import MicroUICore

struct HomeItemDetailView: View {

    @State private var viewModel: HomeItemDetailViewModel

    init(item: HomeItem) {
        _viewModel = State(initialValue: HomeItemDetailViewModel(item: item))
    }

    var body: some View {
        List {
            // MARK: Account Header
            Section {
                VStack(spacing: OwlsSpacing.sm) {
                    Image(systemName: viewModel.item.iconName)
                        .font(.largeTitle)
                        .foregroundStyle(OwlsColor.primary)

                    Text(viewModel.item.title)
                        .font(OwlsTypography.title)

                    if let amount = viewModel.item.amount {
                        Text(amount, format: .currency(code: "USD"))
                            .font(OwlsTypography.largeTitle)
                            .foregroundStyle(amount >= 0 ? OwlsColor.label : .red)
                    }

                    Text(viewModel.item.subtitle)
                        .font(OwlsTypography.caption)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, OwlsSpacing.lg)
            }

            // MARK: Transactions
            Section("Recent Transactions") {
                ForEach(viewModel.recentTransactions) { txn in
                    HStack {
                        VStack(alignment: .leading, spacing: OwlsSpacing.xxs) {
                            Text(txn.description)
                                .font(OwlsTypography.body)
                            Text(txn.date, style: .date)
                                .font(OwlsTypography.caption)
                                .foregroundStyle(OwlsColor.secondaryLabel)
                        }
                        Spacer()
                        Text(txn.amount, format: .currency(code: "USD"))
                            .font(OwlsTypography.callout)
                            .foregroundStyle(txn.amount >= 0 ? OwlsColor.primary : .red)
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
