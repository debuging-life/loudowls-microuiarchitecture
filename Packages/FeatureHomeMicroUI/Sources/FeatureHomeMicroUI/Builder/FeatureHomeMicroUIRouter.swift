import SwiftUI
import MicroUICore

enum FeatureHomeMicroUIRouter: OwlsRouter {

    case detail(Story)

    var id: String {
        switch self {
        case .detail(let story): "home-detail-\(story.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let story):
            StoryDetailView(story: story)
        }
    }
}
