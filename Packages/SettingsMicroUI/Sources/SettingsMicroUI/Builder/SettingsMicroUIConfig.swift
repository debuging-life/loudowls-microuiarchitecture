import MicroUICore
import Factory

public struct SettingsMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.settingsScreenBuilder.register {
            SettingsMicroUIScreenBuilder()
        }
    }
}
