import SwiftUI
import MicroUICore

enum FeatureHomeMicroUIRouter: OwlsRouter {

    case detail(HomeItem)

    // MARK: - Identifiable

    var id: String {
        switch self {
        case .detail(let item): "home-detail-\(item.id)"
        }
    }

    // MARK: - Route Resolution

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            HomeItemDetailView(item: item)
        }
    }
}
