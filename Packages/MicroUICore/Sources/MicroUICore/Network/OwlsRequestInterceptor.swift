import Foundation
import Factory

// MARK: - Interceptor Protocol

public protocol OwlsRequestInterceptor: Sendable {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}

// MARK: - Auth Interceptor

public struct OwlsAuthInterceptor: OwlsRequestInterceptor {

    public init() {}

    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        let authProvider = Container.shared.authTokenProvider()
        var mutableRequest = request

        if let provider = authProvider {
            let token = try await provider.token()
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return mutableRequest
    }
}

// MARK: - Logging Interceptor

public struct OwlsLoggingInterceptor: OwlsRequestInterceptor {

    public init() {}

    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        #if DEBUG
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"
        print("[Network] \(method) \(url)")
        #endif
        return request
    }
}
