import SwiftUI

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
