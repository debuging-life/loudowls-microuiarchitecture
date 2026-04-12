import Foundation
import Factory

// MARK: - Language Code

public enum OwlsLanguageCode: String, Sendable, CaseIterable {
    case en, es, fr, de, zh, ja, ko, ar, hi, pt
}

// MARK: - Language Provider Protocol

public protocol OwlsLanguageProvider: Sendable {
    var currentLanguage: OwlsLanguageCode { get }
    func localizedString(_ key: String, defaultValue: String, comment: String) -> String
    func fetchTranslations(for language: OwlsLanguageCode) async throws
}

// MARK: - Localization Engine

public final class OwlsLocalization: @unchecked Sendable {

    public static let shared = OwlsLocalization()

    private init() {}

    // MARK: - Resolve String

    public static func localizedString(
        _ key: String,
        defaultValue: String? = nil,
        comment: String
    ) -> String {
        let provider = Container.shared.languageProvider()

        // If a language provider is registered and has a translation, use it
        if let provider {
            let resolved = provider.localizedString(key, defaultValue: defaultValue ?? comment, comment: comment)
            if resolved != key { return resolved }
        }

        // Fallback: use the comment as English default
        return defaultValue ?? comment
    }
}

// MARK: - Container + Language Provider

extension Container {
    public var languageProvider: Factory<OwlsLanguageProvider?> { self { nil } }
}
