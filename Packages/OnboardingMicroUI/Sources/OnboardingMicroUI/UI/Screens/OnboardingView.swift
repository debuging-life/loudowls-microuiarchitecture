import SwiftUI
import MicroUICore

struct OnboardingView: View {

    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    private let pages = OnboardingPage.defaults

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            // MARK: Bottom Buttons
            VStack(spacing: OwlsSpacing.md) {
                if currentPage < pages.count - 1 {
                    OwlsButton("Next") {
                        withAnimation { currentPage += 1 }
                    }

                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(OwlsTypography.callout)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                } else {
                    OwlsButton("Get Started") {
                        completeOnboarding()
                    }
                }
            }
            .padding(OwlsSpacing.xl)
        }
        .background(OwlsColor.background)
    }

    private func completeOnboarding() {
        hasSeenOnboarding = true
        OwlsAnalytics.track(.buttonTapped("Complete Onboarding", screen: "Onboarding"))
        OwlsEventBus.shared.post(OwlsEvent("onboarding.completed"))
    }
}

// MARK: - Page View

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: OwlsSpacing.xxl) {
            Spacer()

            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(OwlsColor.primary)

            VStack(spacing: OwlsSpacing.md) {
                Text(page.title)
                    .font(OwlsTypography.largeTitle)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(OwlsTypography.body)
                    .foregroundStyle(OwlsColor.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, OwlsSpacing.xl)
            }

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page Model

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String

    static let defaults: [OnboardingPage] = [
        OnboardingPage(
            icon: "book.fill",
            title: "Discover Stories",
            description: "Explore a world of enchanting stories crafted for curious young minds."
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Save Favorites",
            description: "Bookmark the stories you love and read them again and again."
        ),
        OnboardingPage(
            icon: "moon.stars.fill",
            title: "Bedtime Mode",
            description: "Cozy reading experience with dark mode and gentle animations."
        ),
    ]
}
