import Foundation

// MARK: - Localized String Helper

public struct OwlsLocalizedStringKey {

    private let key: String
    private let defaultValue: String?
    private let comment: String

    public init(_ key: String, defaultValue: String? = nil, comment: String) {
        self.key = key
        self.defaultValue = defaultValue
        self.comment = comment
    }

    public var localized: String {
        OwlsLocalization.localizedString(key, defaultValue: defaultValue, comment: comment)
    }
}

// MARK: - Convenience

public func owlsLocalized(_ key: String, comment: String) -> String {
    OwlsLocalization.localizedString(key, comment: comment)
}
