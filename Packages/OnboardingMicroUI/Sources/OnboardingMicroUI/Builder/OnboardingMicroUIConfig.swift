import MicroUICore
import Factory

public struct OnboardingMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.onboardingScreenBuilder.register {
            OnboardingMicroUIScreenBuilder()
        }
    }
}
