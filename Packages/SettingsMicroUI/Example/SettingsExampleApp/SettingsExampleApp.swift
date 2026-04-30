import SwiftUI
import MicroUICore
import SettingsMicroUI

@main
struct SettingsExampleApp: App {

    init() {
        ExampleBootstrap.run()
        OwlsImageCache.configure()
    }

    var body: some Scene {
        WindowGroup {
            SettingsMicroUIConfig.makeScreen()
                .owlsErrorAlert()
                #if DEBUG
                .overlay(alignment: .bottomTrailing) { OwlsDebugButton() }
                #endif
        }
    }
}
