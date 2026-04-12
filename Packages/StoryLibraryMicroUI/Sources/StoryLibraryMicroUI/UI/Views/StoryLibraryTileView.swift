import SwiftUI
import MicroUICore

struct StoryLibraryTileView: View {

    @Injected(\.storylibraryNavigationCoordinator) private var coordinator

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                Image(systemName: "book.fill")
                    .font(.title)
                    .foregroundStyle(OwlsColor.primary)

                Text("StoryLibrary")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text("Browse stories")
                    .font(OwlsTypography.caption)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }
            .frame(maxWidth: .infinity)
            .padding(OwlsSpacing.lg)
            .background(OwlsColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
        }
        .buttonStyle(.plain)
    }
}
