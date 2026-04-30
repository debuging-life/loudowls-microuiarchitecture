import SwiftUI
import MicroUICore
import FeatureProfileMicroUI

@main
struct ProfileExampleApp: App {

    init() {
        ExampleBootstrap.run()
        OwlsImageCache.configure()
    }

    var body: some Scene {
        WindowGroup {
            FeatureProfileMicroUIConfig.makeScreen()
                .owlsErrorAlert()
                #if DEBUG
                .overlay(alignment: .bottomTrailing) { OwlsDebugButton() }
                #endif
        }
    }
}
