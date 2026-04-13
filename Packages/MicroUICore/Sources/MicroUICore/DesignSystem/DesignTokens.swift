import SwiftUI
import UIKit

// MARK: - Colors

public enum OwlsColor {
    public static let primary = Color(hex: 0x5FA052)
    public static let secondary = Color(hex: 0x040506)

    public static let background = Color(uiColor: .systemBackground)
    public static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    public static let label = Color(uiColor: .label)
    public static let secondaryLabel = Color(uiColor: .secondaryLabel)
}

// MARK: - Spacing

public enum OwlsSpacing {
    public static let xxs: CGFloat = 2
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 48
}

// MARK: - Corner Radius

public enum OwlsRadius {
    public static let sm: CGFloat = 4
    public static let md: CGFloat = 8
    public static let lg: CGFloat = 12
    public static let xl: CGFloat = 16
    public static let pill: CGFloat = 999
}
