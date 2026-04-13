import Foundation
import Factory

// MARK: - Environment

public enum OwlsEnvironment: String, Sendable, CaseIterable {
    case dev
    case staging
    case prod

    public var baseURL: URL {
        switch self {
        case .dev: URL(string: "https://dev-api.example.com")!
        case .staging: URL(string: "https://staging-api.example.com")!
        case .prod: URL(string: "https://api.example.com")!
        }
    }

    public var name: String {
        switch self {
        case .dev: "Development"
        case .staging: "Staging"
        case .prod: "Production"
        }
    }

    public var isDebug: Bool { self != .prod }
}

// MARK: - App Config

public final class OwlsAppConfig: @unchecked Sendable {

    public static let shared = OwlsAppConfig()

    public private(set) var environment: OwlsEnvironment

    private init() {
        #if DEBUG
        environment = .dev
        #else
        environment = .prod
        #endif
    }

    public func setEnvironment(_ env: OwlsEnvironment) {
        environment = env
        Container.shared.apiBaseURL.register { env.baseURL }

        OwlsLogger.info("Environment switched to \(env.name)", module: "Config")
        OwlsEventBus.shared.post(OwlsEvent("environment.changed", data: ["env": env.rawValue]))
    }
}

// MARK: - Container Override

extension Container {
    public var appConfig: Factory<OwlsAppConfig> {
        self { OwlsAppConfig.shared }.scope(.singleton)
    }
}
