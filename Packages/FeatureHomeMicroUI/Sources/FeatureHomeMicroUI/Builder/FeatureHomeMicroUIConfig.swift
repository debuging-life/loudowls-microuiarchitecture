import MicroUICore
import Factory

public struct FeatureHomeMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.homeTileBuilder.register {
            FeatureHomeMicroUITileBuilder()
        }
        Container.shared.homeScreenBuilder.register {
            FeatureHomeMicroUIScreenBuilder()
        }
    }
}
