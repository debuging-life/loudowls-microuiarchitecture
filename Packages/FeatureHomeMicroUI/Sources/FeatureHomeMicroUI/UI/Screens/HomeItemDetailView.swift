import SwiftUI
import MicroUICore

struct StoryDetailView: View {

    let story: Story
    @State private var fullScreenStory: Story?

    var body: some View {
        ScrollView {
            VStack(spacing: OwlsSpacing.xl) {
                // MARK: Cover
                VStack(spacing: OwlsSpacing.md) {
                    Image(systemName: story.coverIcon)
                        .font(.system(size: 60))
                        .foregroundStyle(OwlsColor.primary)
                        .frame(width: 120, height: 120)
                        .background(OwlsColor.primary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.xl))

                    if story.isFavorite {
                        OwlsBadge(.dot, color: .red)
                    }
                }

                // MARK: Info
                VStack(spacing: OwlsSpacing.sm) {
                    Text(story.title)
                        .font(OwlsTypography.largeTitle)
                        .multilineTextAlignment(.center)

                    Text("by \(story.author)")
                        .font(OwlsTypography.callout)
                        .foregroundStyle(OwlsColor.secondaryLabel)

                    HStack(spacing: OwlsSpacing.lg) {
                        Label("\(story.readTime) min", systemImage: "clock")
                        Label(story.isFavorite ? "Favorite" : "Not Favorite", systemImage: story.isFavorite ? "heart.fill" : "heart")
                    }
                    .font(OwlsTypography.caption)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                }

                // MARK: Summary
                VStack(alignment: .leading, spacing: OwlsSpacing.sm) {
                    Text("Summary")
                        .font(OwlsTypography.headline)

                    Text(story.summary)
                        .font(OwlsTypography.body)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: Read Button — fullscreen
                OwlsButton("Read Full Story") {
                    fullScreenStory = story
                }
            }
            .padding(OwlsSpacing.lg)
        }
        .navigationTitle(story.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $fullScreenStory) { story in
            StoryFullScreenView(story: story)
        }
        .trackScreen("StoryDetail", module: "FeatureHomeMicroUI")
    }
}
