import SwiftUI
import MicroUICore

struct OwlScreenDetailView: View {

    let item: OwlScreenItem

    var body: some View {
        List {
            Section {
                VStack(spacing: OwlsSpacing.sm) {
                    Image(systemName: item.iconName)
                        .font(.largeTitle)
                        .foregroundStyle(OwlsColor.primary)

                    Text(item.title)
                        .font(OwlsTypography.title)

                    Text(item.subtitle)
                        .font(OwlsTypography.callout)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, OwlsSpacing.lg)
            }

            Section("Details") {
                LabeledContent("ID", value: item.id)
                LabeledContent("Created", value: item.createdAt, format: .dateTime)
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}