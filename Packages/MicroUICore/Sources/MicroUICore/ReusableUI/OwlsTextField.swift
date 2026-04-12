import SwiftUI

public struct OwlsTextField: View {

    public enum ValidationState {
        case idle
        case valid
        case invalid(String)
    }

    // MARK: - Properties

    private let label: String
    private let placeholder: String
    @Binding private var text: String
    private let validation: ValidationState
    private let keyboardType: UIKeyboardType

    public init(
        _ label: String,
        placeholder: String = "",
        text: Binding<String>,
        validation: ValidationState = .idle,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.validation = validation
        self.keyboardType = keyboardType
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: OwlsSpacing.xs) {
            Text(label)
                .font(OwlsTypography.caption)
                .foregroundStyle(OwlsColor.secondaryLabel)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(OwlsSpacing.md)
                .background(OwlsColor.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: OwlsRadius.md)
                        .stroke(borderColor, lineWidth: 1)
                )

            if case .invalid(let message) = validation {
                Text(message)
                    .font(OwlsTypography.footnote)
                    .foregroundStyle(.red)
            }
        }
    }

    private var borderColor: Color {
        switch validation {
        case .idle: .clear
        case .valid: OwlsColor.primary
        case .invalid: .red
        }
    }
}
