import SwiftUI
import MicroUICore
import Factory

public struct AuthMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.authScreenBuilder.register {
            AuthMicroUIScreenBuilder()
        }
    }

    /// Factory for Example apps and host apps.
    @MainActor
    public static func makeScreen() -> AnyView {
        AuthMicroUIScreenBuilder().buildScreen()
    }
}
