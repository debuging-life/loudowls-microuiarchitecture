import SwiftUI

public struct OwlsAvatar: View {

    public enum Size: CGFloat {
        case small = 32
        case medium = 48
        case large = 80
    }

    public enum Content {
        case initials(String)
        case icon(String)
    }

    private let content: Content
    private let size: Size
    private let backgroundColor: Color

    public init(
        _ content: Content,
        size: Size = .medium,
        backgroundColor: Color = OwlsColor.primary
    ) {
        self.content = content
        self.size = size
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size.rawValue, height: size.rawValue)

            switch content {
            case .initials(let text):
                Text(text)
                    .font(font)
                    .foregroundStyle(.white)
            case .icon(let name):
                Image(systemName: name)
                    .font(font)
                    .foregroundStyle(.white)
            }
        }
    }

    private var font: Font {
        switch size {
        case .small: OwlsTypography.caption
        case .medium: OwlsTypography.callout
        case .large: OwlsTypography.title
        }
    }
}
