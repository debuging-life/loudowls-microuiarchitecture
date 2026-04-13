import SwiftUI
import MicroUICore

struct StoryFullScreenView: View {

    let story: Story
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: OwlsSpacing.xxl) {
                    // Cover
                    Image(systemName: story.coverIcon)
                        .font(.system(size: 80))
                        .foregroundStyle(OwlsColor.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, OwlsSpacing.xxl)

                    // Title
                    VStack(spacing: OwlsSpacing.sm) {
                        Text(story.title)
                            .font(OwlsTypography.largeTitle)
                            .multilineTextAlignment(.center)

                        Text("by \(story.author)")
                            .font(OwlsTypography.title)
                            .foregroundStyle(OwlsColor.secondaryLabel)
                    }

                    // Story Content
                    VStack(alignment: .leading, spacing: OwlsSpacing.lg) {
                        Text(story.summary)
                            .font(.title3)
                            .lineSpacing(8)

                        Text("Once upon a time, in a land filled with wonder and magic, this story began. The characters you'll meet are brave, kind, and curious — just like you.")
                            .font(.title3)
                            .lineSpacing(8)

                        Text("And they all lived happily ever after.")
                            .font(.title3)
                            .italic()
                            .lineSpacing(8)
                            .padding(.top, OwlsSpacing.lg)

                        Text("— The End —")
                            .font(OwlsTypography.title)
                            .frame(maxWidth: .infinity)
                            .padding(.top, OwlsSpacing.xxl)
                    }
                    .padding(.horizontal, OwlsSpacing.lg)
                }
                .padding(OwlsSpacing.lg)
            }
            .navigationTitle("Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .trackScreen("StoryReader", module: "FeatureHomeMicroUI")
    }
}
