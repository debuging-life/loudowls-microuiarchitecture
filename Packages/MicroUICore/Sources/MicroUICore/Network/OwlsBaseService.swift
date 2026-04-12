import Foundation
import Factory

// MARK: - Base Service

open class OwlsBaseService: @unchecked Sendable {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let interceptors: [OwlsRequestInterceptor]

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .owlsDefault,
        interceptors: [OwlsRequestInterceptor]? = nil
    ) {
        self.session = session
        self.decoder = decoder
        self.interceptors = interceptors ?? Self.defaultInterceptors
    }

    // MARK: - Default Interceptors

    private static var defaultInterceptors: [OwlsRequestInterceptor] {
        [OwlsLoggingInterceptor(), OwlsAuthInterceptor()]
    }

    // MARK: - Request (with response)

    public func request<T: Decodable & Sendable>(
        _ route: some OwlsAPIRoute,
        baseURL: URL? = nil
    ) async throws -> T {
        let base = baseURL ?? Container.shared.apiBaseURL()
        var urlRequest = route.toURLRequest(baseURL: base)

        for interceptor in interceptors {
            urlRequest = try await interceptor.intercept(urlRequest)
        }

        let (data, response) = try await performRequest(urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OwlsNetworkError.networkFailure("Invalid response type")
        }

        if let error = OwlsNetworkError.fromStatusCode(httpResponse.statusCode) {
            if case .unauthorized = error {
                return try await retryWithRefresh(route, baseURL: base)
            }
            throw error
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw OwlsNetworkError.decodingFailed(error.localizedDescription)
        }
    }

    // MARK: - Request (no response body)

    public func requestVoid(
        _ route: some OwlsAPIRoute,
        baseURL: URL? = nil
    ) async throws {
        let base = baseURL ?? Container.shared.apiBaseURL()
        var urlRequest = route.toURLRequest(baseURL: base)

        for interceptor in interceptors {
            urlRequest = try await interceptor.intercept(urlRequest)
        }

        let (_, response) = try await performRequest(urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OwlsNetworkError.networkFailure("Invalid response type")
        }

        if let error = OwlsNetworkError.fromStatusCode(httpResponse.statusCode) {
            throw error
        }
    }

    // MARK: - Retry with Token Refresh

    private func retryWithRefresh<T: Decodable & Sendable>(
        _ route: some OwlsAPIRoute,
        baseURL: URL
    ) async throws -> T {
        let authProvider = Container.shared.authTokenProvider()

        guard let provider = authProvider else {
            throw OwlsNetworkError.unauthorized
        }

        _ = try await provider.refreshToken()

        var urlRequest = route.toURLRequest(baseURL: baseURL)
        for interceptor in interceptors {
            urlRequest = try await interceptor.intercept(urlRequest)
        }

        let (data, response) = try await performRequest(urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OwlsNetworkError.networkFailure("Invalid response type")
        }

        if let error = OwlsNetworkError.fromStatusCode(httpResponse.statusCode) {
            throw error
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw OwlsNetworkError.decodingFailed(error.localizedDescription)
        }
    }

    // MARK: - Perform

    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw OwlsNetworkError.networkFailure(error.localizedDescription)
        }
    }
}

// MARK: - JSONDecoder Default

extension JSONDecoder {
    public static var owlsDefault: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

// MARK: - Container + Base URL

extension Container {
    public var apiBaseURL: Factory<URL> {
        self { URL(string: "https://api.example.com")! }.scope(.singleton)
    }
}
