import MicroUICore
import Factory

public struct AboutScreenMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.aboutscreenTileBuilder.register {
            AboutScreenMicroUITileBuilder()
        }
        Container.shared.aboutscreenScreenBuilder.register {
            AboutScreenMicroUIScreenBuilder()
        }
    }
}
