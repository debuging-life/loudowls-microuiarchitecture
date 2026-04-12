import SwiftUI

public protocol OwlsRouter: Hashable, Identifiable {
    associatedtype Body: View
    @MainActor @ViewBuilder func resolveViewForRoute() -> Body
}
