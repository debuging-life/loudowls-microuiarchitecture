import SwiftUI

public struct OwlsCard<Content: View>: View {

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(OwlsSpacing.lg)
            .background(OwlsColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}
