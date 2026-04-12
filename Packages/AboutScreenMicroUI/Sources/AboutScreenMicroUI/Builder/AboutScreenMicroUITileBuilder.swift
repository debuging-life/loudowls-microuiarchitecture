import SwiftUI
import MicroUICore

struct AboutScreenMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(AboutScreenTileView())
    }
}
