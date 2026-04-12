import SwiftUI
import MicroUICore

struct TransfersMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(TransfersTileView())
    }
}
