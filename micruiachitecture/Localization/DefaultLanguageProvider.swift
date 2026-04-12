import Foundation
import MicroUICore

// MARK: - Default Language Provider

final class DefaultLanguageProvider: OwlsLanguageProvider, @unchecked Sendable {

    private(set) var currentLanguage: OwlsLanguageCode = .en
    private var translations: [String: String] = [:]

    // MARK: - Resolve

    func localizedString(_ key: String, defaultValue: String, comment: String) -> String {
        // If English, return the default (comment text)
        if currentLanguage == .en {
            return defaultValue
        }
        // Otherwise look up from server-fetched translations
        return translations[key] ?? defaultValue
    }

    // MARK: - Fetch from Server

    func fetchTranslations(for language: OwlsLanguageCode) async throws {
        currentLanguage = language

        if language == .en {
            translations = [:]
            return
        }

        // TODO: Replace with real API call
        // GET /api/translations?lang=es
        // Response: { "home.title": "Inicio", "profile.title": "Perfil", ... }
        try await Task.sleep(for: .milliseconds(500))

        // Mock translations for demo
        translations = Self.mockTranslations(for: language)
    }

    // MARK: - Mock Data

    private static func mockTranslations(for language: OwlsLanguageCode) -> [String: String] {
        switch language {
        case .es:
            [
                "home.title": "Inicio",
                "home.accounts": "Cuentas",
                "profile.title": "Perfil",
                "profile.edit": "Editar Perfil",
                "auth.sign_in": "Iniciar Sesión",
                "auth.sign_out": "Cerrar Sesión",
                "common.loading": "Cargando…",
                "common.retry": "Reintentar",
                "common.close": "Cerrar",
            ]
        case .fr:
            [
                "home.title": "Accueil",
                "home.accounts": "Comptes",
                "profile.title": "Profil",
                "profile.edit": "Modifier le Profil",
                "auth.sign_in": "Se Connecter",
                "auth.sign_out": "Se Déconnecter",
                "common.loading": "Chargement…",
                "common.retry": "Réessayer",
                "common.close": "Fermer",
            ]
        default:
            [:]
        }
    }
}
