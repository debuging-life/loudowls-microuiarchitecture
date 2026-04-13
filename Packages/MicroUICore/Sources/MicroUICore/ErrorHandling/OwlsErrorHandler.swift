import SwiftUI
import Observation

// MARK: - Global Error Handler

@Observable
public final class OwlsErrorHandler: @unchecked Sendable {

    public static let shared = OwlsErrorHandler()

    public var currentError: OwlsAppError?
    public var isErrorPresented: Bool = false

    private init() {}

    // MARK: - Handle

    public func handle(_ error: Error, module: String = "", screen: String = "") {
        let appError = OwlsAppError(error: error, module: module, screen: screen)

        OwlsLogger.error(error.localizedDescription, module: module, error: error)
        OwlsAnalytics.track(.errorOccurred(error.localizedDescription, module: module, screen: screen))

        // Check if it's an auth error — force logout
        if let networkError = error as? OwlsNetworkError, case .unauthorized = networkError {
            OwlsEventBus.shared.post(.userLoggedOut)
            return
        }

        // Show error to user
        currentError = appError
        isErrorPresented = true
    }

    // MARK: - Dismiss

    public func dismiss() {
        currentError = nil
        isErrorPresented = false
    }
}

// MARK: - App Error

public struct OwlsAppError: Identifiable {
    public let id = UUID()
    public let message: String
    public let module: String
    public let screen: String
    public let timestamp: Date

    init(error: Error, module: String, screen: String) {
        self.message = error.localizedDescription
        self.module = module
        self.screen = screen
        self.timestamp = Date()
    }
}

// MARK: - View Modifier

extension View {
    public func owlsErrorAlert() -> some View {
        modifier(OwlsErrorAlertModifier())
    }
}

private struct OwlsErrorAlertModifier: ViewModifier {
    var errorHandler = OwlsErrorHandler.shared

    func body(content: Content) -> some View {
        content
            .alert(
                "Something went wrong",
                isPresented: Bindable(errorHandler).isErrorPresented,
                presenting: errorHandler.currentError
            ) { _ in
                Button("OK") { errorHandler.dismiss() }
            } message: { error in
                Text(error.message)
            }
    }
}
