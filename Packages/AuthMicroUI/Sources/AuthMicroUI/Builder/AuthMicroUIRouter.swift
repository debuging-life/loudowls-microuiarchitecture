import SwiftUI
import MicroUICore

enum AuthMicroUIRouter: OwlsRouter {

    case placeholder

    var id: String {
        switch self {
        case .placeholder: "auth-placeholder"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .placeholder:
            EmptyView()
        }
    }
}
