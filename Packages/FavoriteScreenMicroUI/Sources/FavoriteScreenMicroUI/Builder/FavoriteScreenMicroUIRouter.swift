import SwiftUI
import MicroUICore

enum FavoriteScreenMicroUIRouter: OwlsRouter {

    case detail(FavoriteScreenItem)

    var id: String {
        switch self {
        case .detail(let item): "favoritescreen-detail-\(item.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            FavoriteScreenDetailView(item: item)
        }
    }
}