import SwiftUI

public struct OwlsAlert: View {

    public enum Severity {
        case info, success, warning, error
    }

    private let severity: Severity
    private let message: String
    private let onDismiss: (() -> Void)?

    public init(_ severity: Severity, message: String, onDismiss: (() -> Void)? = nil) {
        self.severity = severity
        self.message = message
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: OwlsSpacing.md) {
            Image(systemName: iconName)
                .foregroundStyle(tintColor)

            Text(message)
                .font(OwlsTypography.callout)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let onDismiss {
                Button { onDismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
            }
        }
        .padding(OwlsSpacing.md)
        .background(tintColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: OwlsRadius.md)
                .stroke(tintColor.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Severity Config

    private var iconName: String {
        switch severity {
        case .info: "info.circle.fill"
        case .success: "checkmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .error: "xmark.octagon.fill"
        }
    }

    private var tintColor: Color {
        switch severity {
        case .info: .blue
        case .success: OwlsColor.primary
        case .warning: .orange
        case .error: .red
        }
    }
}
