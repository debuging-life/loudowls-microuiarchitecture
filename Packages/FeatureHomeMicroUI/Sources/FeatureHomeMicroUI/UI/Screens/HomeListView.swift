import SwiftUI
import MicroUICore

struct HomeListView: View {

    @State private var viewModel: HomeListViewModel
    @State private var path = NavigationPath()
    @State private var fullScreenStory: Story?

    init(viewModel: HomeListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if viewModel.isLoading {
                    OwlsLoadingView("Loading stories…")
                } else if let error = viewModel.errorMessage {
                    OwlsEmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Something went wrong",
                        description: error,
                        actionTitle: "Retry"
                    ) { Task { await viewModel.loadStories() } }
                } else if viewModel.stories.isEmpty {
                    OwlsEmptyState(icon: "book", title: "No Stories Yet", description: "Tap + to create your first story.")
                } else {
                    storyList
                }
            }
            .navigationTitle("Stories")
            // MARK: Push — detail screen
            .navigationDestination(for: FeatureHomeMicroUIRouter.self) { route in
                route.resolveViewForRoute()
            }
            .toolbar {
                // MARK: Sheet — create story
                ToolbarItem(placement: .topBarTrailing) {
                    Button { viewModel.isCreateSheetPresented = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // MARK: Sheet presentation
            .sheet(isPresented: $viewModel.isCreateSheetPresented) {
                StoryCreateSheet(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            // MARK: Fullscreen presentation
            .fullScreenCover(item: $fullScreenStory) { story in
                StoryFullScreenView(story: story)
            }
        }
        .task { await viewModel.loadStories() }
        .trackScreen("StoryList", module: "FeatureHomeMicroUI")
    }

    // MARK: - Story List

    private var storyList: some View {
        List {
            ForEach(viewModel.stories) { story in
                Button {
                    // Navigation: push to detail screen
                    path.append(FeatureHomeMicroUIRouter.detail(story))
                } label: {
                    StoryRow(story: story) {
                        // Fullscreen: open reader
                        fullScreenStory = story
                    } onFavorite: {
                        viewModel.toggleFavorite(id: story.id)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let story = viewModel.stories[index]
                    Task { await viewModel.deleteStory(id: story.id) }
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Story Row

private struct StoryRow: View {
    let story: Story
    let onFullScreen: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        HStack(spacing: OwlsSpacing.md) {
            // Cover Icon
            Image(systemName: story.coverIcon)
                .font(.title2)
                .foregroundStyle(OwlsColor.primary)
                .frame(width: 44, height: 44)
                .background(OwlsColor.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))

            // Info
            VStack(alignment: .leading, spacing: OwlsSpacing.xxs) {
                Text(story.title)
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)
                Text(story.author)
                    .font(OwlsTypography.caption)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                Text("\(story.readTime) min read")
                    .font(OwlsTypography.footnote)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }

            Spacer()

            // Favorite
            Button { onFavorite() } label: {
                Image(systemName: story.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(story.isFavorite ? .red : OwlsColor.secondaryLabel)
            }
            .buttonStyle(.plain)

            // Fullscreen
            Button { onFullScreen() } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.caption)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, OwlsSpacing.xs)
    }
}
