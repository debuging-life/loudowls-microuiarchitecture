import MicroUICore
import Factory

public struct StoryLibraryMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.storylibraryTileBuilder.register {
            StoryLibraryMicroUITileBuilder()
        }
        Container.shared.storylibraryScreenBuilder.register {
            StoryLibraryMicroUIScreenBuilder()
        }
    }
}
