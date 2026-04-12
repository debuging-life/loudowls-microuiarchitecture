import MicroUICore
import Factory

public struct FeatureProfileMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.profileTileBuilder.register {
            FeatureProfileMicroUITileBuilder()
        }
        Container.shared.profileScreenBuilder.register {
            FeatureProfileMicroUIScreenBuilder()
        }
    }
}
