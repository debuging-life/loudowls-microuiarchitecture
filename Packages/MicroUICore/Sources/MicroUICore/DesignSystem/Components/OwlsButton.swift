import SwiftUI

public struct OwlsButton: View {

    // MARK: - Variant

    public enum Variant {
        case primary, secondary, destructive
    }

    // MARK: - Properties

    private let title: String
    private let variant: Variant
    private let action: () -> Void

    public init(_ title: String, variant: Variant = .primary, action: @escaping () -> Void) {
        self.title = title
        self.variant = variant
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(OwlsTypography.headline)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, OwlsSpacing.md)
                .padding(.horizontal, OwlsSpacing.lg)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
        }
    }

    // MARK: - Colors

    private var backgroundColor: Color {
        switch variant {
        case .primary: OwlsColor.primary
        case .secondary: OwlsColor.secondaryBackground
        case .destructive: .red
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary: .white
        case .secondary: OwlsColor.label
        case .destructive: .white
        }
    }
}
