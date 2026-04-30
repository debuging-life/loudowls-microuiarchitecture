import SwiftUI
import MicroUICore
import FeatureHomeMicroUI

@main
struct HomeExampleApp: App {

    init() {
        ExampleBootstrap.run()
        OwlsImageCache.configure()
    }

    var body: some Scene {
        WindowGroup {
            FeatureHomeMicroUIConfig.makeScreen()
                .owlsErrorAlert()
                #if DEBUG
                .overlay(alignment: .bottomTrailing) { OwlsDebugButton() }
                #endif
        }
    }
}
