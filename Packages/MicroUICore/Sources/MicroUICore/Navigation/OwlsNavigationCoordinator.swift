import Observation

@Observable
public final class OwlsNavigationCoordinator: @unchecked Sendable {

    // MARK: - State

    public var isPresented: Bool = false

    // MARK: - Init

    public init() {}

    // MARK: - Actions

    public func present() { isPresented = true }
    public func dismiss() { isPresented = false }
}
