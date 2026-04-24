import SwiftUI
import MicroUICore

enum UnknowMicroUIRouter: OwlsRouter {

    case detail(UnknowItem)

    var id: String {
        switch self {
        case .detail(let item): "unknow-detail-\(item.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            UnknowDetailView(item: item)
        }
    }
}