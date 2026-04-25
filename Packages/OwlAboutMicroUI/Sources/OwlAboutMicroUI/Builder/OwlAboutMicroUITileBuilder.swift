import SwiftUI
import MicroUICore

struct OwlAboutMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(OwlAboutTileView())
    }
}