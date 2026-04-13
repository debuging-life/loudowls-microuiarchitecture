import MicroUICore
import Factory

public struct FeatureHomeMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.homeScreenBuilder.register {
            FeatureHomeMicroUIScreenBuilder()
        }
    }
}
