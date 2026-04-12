import SwiftUI

public struct OwlsBadge: View {

    public enum Style {
        case count(Int)
        case dot
    }

    private let style: Style
    private let color: Color

    public init(_ style: Style, color: Color = .red) {
        self.style = style
        self.color = color
    }

    public var body: some View {
        switch style {
        case .count(let value):
            Text("\(value)")
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(color)
                .clipShape(Capsule())
        case .dot:
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
        }
    }
}

// MARK: - View Modifier

extension View {
    public func owlsBadge(_ count: Int) -> some View {
        overlay(alignment: .topTrailing) {
            if count > 0 {
                OwlsBadge(.count(count))
                    .offset(x: 8, y: -8)
            }
        }
    }

    public func owlsDot(_ visible: Bool = true, color: Color = .red) -> some View {
        overlay(alignment: .topTrailing) {
            if visible {
                OwlsBadge(.dot, color: color)
                    .offset(x: 4, y: -4)
            }
        }
    }
}
