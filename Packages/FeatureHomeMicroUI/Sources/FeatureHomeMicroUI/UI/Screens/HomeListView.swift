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
                switch viewModel.paginator.state {
                case .loading:
                    OwlsLoadingView("Loading stories…")
                case .empty:
                    OwlsEmptyState(icon: "book", title: "No Stories Yet", description: "Tap + to create your first story.")
                case .error(let message):
                    OwlsEmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Something went wrong",
                        description: message,
                        actionTitle: "Retry"
                    ) { Task { await viewModel.paginator.refresh() } }
                default:
                    storyList
                }
            }
            .navigationTitle("Stories")
            .navigationDestination(for: FeatureHomeMicroUIRouter.self) { route in
                route.resolveViewForRoute()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { viewModel.isCreateSheetPresented = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isCreateSheetPresented) {
                StoryCreateSheet(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(item: $fullScreenStory) { story in
                StoryFullScreenView(story: story)
            }
        }
        .task { await viewModel.paginator.loadFirstPage() }
        .refreshable { await viewModel.paginator.refresh() }
        .trackScreen("StoryList", module: "FeatureHomeMicroUI")
    }

    // MARK: - Story List with Infinite Scroll

    private var storyList: some View {
        List {
            ForEach(viewModel.paginator.items) { story in
                Button {
                    path.append(FeatureHomeMicroUIRouter.detail(story))
                } label: {
                    StoryRow(story: story) {
                        fullScreenStory = story
                    } onFavorite: {
                        viewModel.toggleFavorite(id: story.id)
                    }
                }
                .task {
                    // Infinite scroll — load next page when near bottom
                    await viewModel.paginator.loadNextPageIfNeeded(currentItem: story)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let story = viewModel.paginator.items[index]
                    Task { await viewModel.deleteStory(id: story.id) }
                }
            }

            // Loading more spinner
            if viewModel.paginator.state == .loadingMore {
                HStack {
                    Spacer()
                    ProgressView("Loading more…")
                        .padding()
                    Spacer()
                }
                .listRowSeparator(.hidden)
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
            Image(systemName: story.coverIcon)
                .font(.title2)
                .foregroundStyle(OwlsColor.primary)
                .frame(width: 44, height: 44)
                .background(OwlsColor.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))

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

            Button { onFavorite() } label: {
                Image(systemName: story.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(story.isFavorite ? .red : OwlsColor.secondaryLabel)
            }
            .buttonStyle(.plain)

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
