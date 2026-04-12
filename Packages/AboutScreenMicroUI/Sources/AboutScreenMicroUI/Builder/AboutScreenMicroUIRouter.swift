import SwiftUI
import MicroUICore

enum AboutScreenMicroUIRouter: OwlsRouter {

    case placeholder

    var id: String {
        switch self {
        case .placeholder: "aboutscreen-placeholder"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .placeholder:
            Text("AboutScreen Placeholder")
        }
    }
}
