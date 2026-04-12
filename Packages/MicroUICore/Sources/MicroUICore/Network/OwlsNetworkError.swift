import Foundation

public enum OwlsNetworkError: LocalizedError, Sendable {
    case invalidURL
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingFailed(String)
    case noData
    case networkFailure(String)
    case rateLimited(retryAfter: TimeInterval?)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .unauthorized: "Session expired. Please sign in again."
        case .forbidden: "You don't have permission to access this resource."
        case .notFound: "The requested resource was not found."
        case .serverError(let code): "Server error (\(code)). Please try again later."
        case .decodingFailed(let detail): "Failed to process response: \(detail)"
        case .noData: "No data received from server."
        case .networkFailure(let detail): "Network error: \(detail)"
        case .rateLimited: "Too many requests. Please wait and try again."
        }
    }

    static func fromStatusCode(_ code: Int) -> OwlsNetworkError? {
        switch code {
        case 200...299: nil
        case 401: .unauthorized
        case 403: .forbidden
        case 404: .notFound
        case 429: .rateLimited(retryAfter: nil)
        default: .serverError(statusCode: code)
        }
    }
}
