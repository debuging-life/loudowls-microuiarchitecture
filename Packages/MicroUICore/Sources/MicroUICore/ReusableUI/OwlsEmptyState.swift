import SwiftUI

public struct OwlsEmptyState: View {

    private let icon: String
    private let title: String
    private let description: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        icon: String,
        title: String,
        description: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: OwlsSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(OwlsColor.secondaryLabel)

            VStack(spacing: OwlsSpacing.sm) {
                Text(title)
                    .font(OwlsTypography.title)

                Text(description)
                    .font(OwlsTypography.body)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                OwlsButton(actionTitle, action: action)
                    .padding(.horizontal, OwlsSpacing.xxl)
            }
        }
        .padding(OwlsSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
