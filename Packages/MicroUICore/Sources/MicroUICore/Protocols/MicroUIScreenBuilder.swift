import SwiftUI

public protocol MicroUIScreenBuilder {
    @MainActor func buildScreen() -> AnyView
}
