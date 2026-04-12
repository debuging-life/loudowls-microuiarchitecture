import SwiftUI
import MicroUICore

struct AuthMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(AuthTileView())
    }
}
