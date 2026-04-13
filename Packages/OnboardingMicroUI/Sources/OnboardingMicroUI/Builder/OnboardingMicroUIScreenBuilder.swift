import SwiftUI
import MicroUICore

struct OnboardingMicroUIScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        AnyView(OnboardingView())
    }
}
