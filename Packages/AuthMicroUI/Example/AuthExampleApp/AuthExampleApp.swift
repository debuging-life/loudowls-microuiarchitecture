import SwiftUI
import MicroUICore
import AuthMicroUI

@main
struct AuthExampleApp: App {

    init() {
        ExampleBootstrap.run()
        OwlsImageCache.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthMicroUIConfig.makeScreen()
                .owlsErrorAlert()
                #if DEBUG
                .overlay(alignment: .bottomTrailing) { OwlsDebugButton() }
                #endif
        }
    }
}
