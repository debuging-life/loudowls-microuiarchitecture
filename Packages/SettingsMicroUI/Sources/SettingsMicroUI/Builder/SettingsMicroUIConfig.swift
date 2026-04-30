import SwiftUI
import MicroUICore
import Factory

public struct SettingsMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.settingsScreenBuilder.register {
            SettingsMicroUIScreenBuilder()
        }
    }

    /// Factory for Example apps and host apps.
    @MainActor
    public static func makeScreen() -> AnyView {
        SettingsMicroUIScreenBuilder().buildScreen()
    }
}
