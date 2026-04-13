import SwiftUI
import MicroUICore

struct SettingsMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        AnyView(SettingsView())
    }
}
