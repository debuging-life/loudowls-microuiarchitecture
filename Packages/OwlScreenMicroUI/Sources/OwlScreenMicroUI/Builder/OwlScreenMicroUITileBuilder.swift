import SwiftUI
import MicroUICore

struct OwlScreenMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(OwlScreenTileView())
    }
}