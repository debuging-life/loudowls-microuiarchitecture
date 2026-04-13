import SwiftUI

// MARK: - Color + Hex

extension Color {
    public init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}

// MARK: - View Extensions

extension View {
    public func owlsCardStyle() -> some View {
        padding(OwlsSpacing.lg)
            .background(OwlsColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }

    public func owlsScreen() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(OwlsColor.background)
    }
}
