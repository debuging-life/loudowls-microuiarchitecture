import SwiftUI
import MicroUICore
import Factory

public struct FeatureProfileMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.profileScreenBuilder.register {
            FeatureProfileMicroUIScreenBuilder()
        }
    }

    /// Factory for Example apps and host apps.
    @MainActor
    public static func makeScreen() -> AnyView {
        FeatureProfileMicroUIScreenBuilder().buildScreen()
    }
}
