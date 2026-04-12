import SwiftUI
import MicroUICore

struct FeatureHomeMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(HomeTileView())
    }
}
