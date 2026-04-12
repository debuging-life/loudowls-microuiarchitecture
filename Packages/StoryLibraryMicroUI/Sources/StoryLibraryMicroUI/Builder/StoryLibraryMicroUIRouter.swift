import SwiftUI
import MicroUICore

enum StoryLibraryMicroUIRouter: OwlsRouter {

    case detail(StoryLibraryItem)

    var id: String {
        switch self {
        case .detail(let item): "storylibrary-detail-\(item.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            StoryLibraryDetailView(item: item)
        }
    }
}
