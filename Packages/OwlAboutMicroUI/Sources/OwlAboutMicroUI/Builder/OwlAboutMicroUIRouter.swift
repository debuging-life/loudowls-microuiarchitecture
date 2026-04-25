import SwiftUI
import MicroUICore

enum OwlAboutMicroUIRouter: OwlsRouter {

    case detail(OwlAboutItem)

    var id: String {
        switch self {
        case .detail(let item): "owlabout-detail-\(item.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            OwlAboutDetailView(item: item)
        }
    }
}