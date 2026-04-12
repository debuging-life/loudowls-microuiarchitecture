import SwiftUI
import MicroUICore

enum AuthMicroUIRouter: OwlsRouter {

    case tokenDemo

    var id: String {
        switch self {
        case .tokenDemo: "auth-token-demo"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .tokenDemo:
            TokenDemoView()
        }
    }
}
