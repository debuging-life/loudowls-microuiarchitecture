import SwiftUI
import Observation

// MARK: - Presentation Style

public enum OwlsPresentationStyle: Sendable {
    case fullScreen
    case sheet
}

// MARK: - Navigation Coordinator

@Observable
public final class OwlsNavigationCoordinator: @unchecked Sendable {

    // MARK: - State

    public var isPresented: Bool = false
    public var isSheetPresented: Bool = false
    public private(set) var presentationStyle: OwlsPresentationStyle = .fullScreen
    public var data: [String: Any] = [:]

    // MARK: - Init

    public init() {}

    // MARK: - Present

    public func present(style: OwlsPresentationStyle = .fullScreen) {
        presentationStyle = style
        switch style {
        case .fullScreen: isPresented = true
        case .sheet: isSheetPresented = true
        }
    }

    // MARK: - Dismiss

    public func dismiss() {
        isPresented = false
        isSheetPresented = false
        data = [:]
    }

    // MARK: - Data Passing

    public func present(style: OwlsPresentationStyle = .fullScreen, data: [String: Any]) {
        self.data = data
        present(style: style)
    }

    public func value<T>(for key: String) -> T? {
        data[key] as? T
    }
}
