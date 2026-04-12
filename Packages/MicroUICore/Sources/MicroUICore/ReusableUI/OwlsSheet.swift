import SwiftUI

// MARK: - Sheet Modifier

extension View {
    public func owlsSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        showDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        sheet(isPresented: isPresented) {
            content()
                .presentationDetents(detents)
                .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
        }
    }
}

// MARK: - Confirmation Sheet

public struct OwlsConfirmationSheet: View {

    private let title: String
    private let message: String
    private let confirmTitle: String
    private let confirmRole: ButtonRole?
    private let onConfirm: () -> Void
    private let onCancel: () -> Void

    public init(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        confirmRole: ButtonRole? = nil,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.confirmRole = confirmRole
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    public var body: some View {
        VStack(spacing: OwlsSpacing.xl) {
            VStack(spacing: OwlsSpacing.sm) {
                Text(title)
                    .font(OwlsTypography.title)
                Text(message)
                    .font(OwlsTypography.body)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: OwlsSpacing.md) {
                OwlsButton(confirmTitle, variant: confirmRole == .destructive ? .destructive : .primary) {
                    onConfirm()
                }
                OwlsButton("Cancel", variant: .secondary) {
                    onCancel()
                }
            }
        }
        .padding(OwlsSpacing.xl)
    }
}
