import SwiftUI
import MicroUICore
import Factory

struct StoryLibraryMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = MockStoryLibraryDataSource()
        let dispatcher = StoryLibraryServiceDispatcher(dataSource: dataSource)
        let repository = DefaultStoryLibraryRepository(dispatcher: dispatcher)
        let viewModel = StoryLibraryMicroUIViewModel(repository: repository)
        return AnyView(StoryLibraryMicroUIView(viewModel: viewModel))
    }
}
