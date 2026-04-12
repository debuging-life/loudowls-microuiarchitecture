import SwiftUI

public struct OwlsLoadingView: View {

    private let message: String?

    public init(_ message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: OwlsSpacing.md) {
            ProgressView()
                .controlSize(.large)

            if let message {
                Text(message)
                    .font(OwlsTypography.callout)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Skeleton Row

public struct OwlsSkeletonRow: View {

    public init() {}

    public var body: some View {
        HStack(spacing: OwlsSpacing.md) {
            RoundedRectangle(cornerRadius: OwlsRadius.sm)
                .fill(OwlsColor.secondaryBackground)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: OwlsSpacing.xs) {
                RoundedRectangle(cornerRadius: OwlsRadius.sm)
                    .fill(OwlsColor.secondaryBackground)
                    .frame(height: 14)
                    .frame(maxWidth: 200)

                RoundedRectangle(cornerRadius: OwlsRadius.sm)
                    .fill(OwlsColor.secondaryBackground)
                    .frame(height: 12)
                    .frame(maxWidth: 120)
            }
        }
        .redacted(reason: .placeholder)
        .shimmer()
    }
}

// MARK: - Shimmer

extension View {
    public func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.3), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}
