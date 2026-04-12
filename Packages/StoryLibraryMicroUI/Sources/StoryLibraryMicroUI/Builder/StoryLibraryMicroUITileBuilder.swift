import SwiftUI
import MicroUICore

struct StoryLibraryMicroUITileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(StoryLibraryTileView())
    }
}
