import SwiftUI
import MicroUICore

struct FavoriteScreenMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(FavoriteScreenTileView())
    }
}