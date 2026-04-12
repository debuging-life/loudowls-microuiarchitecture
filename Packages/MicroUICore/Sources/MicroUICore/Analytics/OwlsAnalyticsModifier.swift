import SwiftUI

// MARK: - View Modifier for Screen Tracking

extension View {
    public func trackScreen(_ name: String, module: String) -> some View {
        onAppear {
            OwlsAnalytics.track(.screenViewed(name, module: module))
        }
    }
}
