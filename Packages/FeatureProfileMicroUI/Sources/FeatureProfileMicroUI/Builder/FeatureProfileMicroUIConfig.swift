import MicroUICore
import Factory

public struct FeatureProfileMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.profileScreenBuilder.register {
            FeatureProfileMicroUIScreenBuilder()
        }
    }
}
