import SwiftUI
import MicroUICore

struct FeatureProfileMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(ProfileTileView())
    }
}
