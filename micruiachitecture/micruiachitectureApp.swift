import SwiftUI
import MicroUICore

@main
struct MicruiachitectureApp: App {

    // MARK: - Init

    init() {
        MicroUIBootstrap.register()
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
