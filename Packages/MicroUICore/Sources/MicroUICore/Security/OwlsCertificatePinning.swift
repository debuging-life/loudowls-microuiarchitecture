import Foundation
import CryptoKit

// MARK: - Certificate Pinning Delegate

public final class OwlsPinningDelegate: NSObject, URLSessionDelegate, Sendable {

    private let pinnedHashes: Set<String>

    public init(pinnedHashes: Set<String>) {
        self.pinnedHashes = pinnedHashes
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge
    ) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Skip pinning in DEBUG for proxies like Charles
        #if DEBUG
        return (.useCredential, URLCredential(trust: serverTrust))
        #else
        guard validateCertificateChain(serverTrust) else {
            OwlsLogger.critical("Certificate pinning failed for \(challenge.protectionSpace.host)", module: "Security")
            return (.cancelAuthenticationChallenge, nil)
        }

        return (.useCredential, URLCredential(trust: serverTrust))
        #endif
    }

    // MARK: - Validate

    private func validateCertificateChain(_ serverTrust: SecTrust) -> Bool {
        guard let certificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
            return false
        }

        for certificate in certificates {
            let certData = SecCertificateCopyData(certificate) as Data
            let hash = SHA256.hash(data: certData)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()

            if pinnedHashes.contains(hashString) {
                return true
            }
        }

        return false
    }
}

// MARK: - Pinned Session Factory

extension URLSession {
    public static func owlsPinned(hashes: Set<String>) -> URLSession {
        let delegate = OwlsPinningDelegate(pinnedHashes: hashes)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        return URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
    }
}
