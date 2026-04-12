import SwiftUI
import MicroUICore

enum TransfersMicroUIRouter: OwlsRouter {

    case placeholder

    var id: String {
        switch self {
        case .placeholder: "transfers-placeholder"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .placeholder:
            Text("Transfers Placeholder")
        }
    }
}
