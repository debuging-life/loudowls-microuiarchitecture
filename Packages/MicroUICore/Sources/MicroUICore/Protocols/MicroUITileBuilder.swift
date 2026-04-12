import SwiftUI

public protocol MicroUITileBuilder {
    @MainActor func buildTile() -> AnyView
}
