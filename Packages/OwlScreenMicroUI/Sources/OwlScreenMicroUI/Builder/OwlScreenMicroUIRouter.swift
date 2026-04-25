import SwiftUI
import MicroUICore

enum OwlScreenMicroUIRouter: OwlsRouter {

    case detail(OwlScreenItem)

    var id: String {
        switch self {
        case .detail(let item): "owlscreen-detail-\(item.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            OwlScreenDetailView(item: item)
        }
    }
}