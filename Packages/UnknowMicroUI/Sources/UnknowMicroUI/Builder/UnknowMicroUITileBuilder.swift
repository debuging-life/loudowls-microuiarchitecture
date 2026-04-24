import SwiftUI
import MicroUICore

struct UnknowMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(UnknowTileView())
    }
}
