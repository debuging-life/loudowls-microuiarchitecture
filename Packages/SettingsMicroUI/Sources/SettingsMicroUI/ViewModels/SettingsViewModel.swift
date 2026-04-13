import Foundation
import Observation
import MicroUICore

@Observable
final class SettingsViewModel {

    // MARK: - Appearance

    var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "owls.settings.darkMode")
            OwlsEventBus.shared.post(.themeChanged)
        }
    }

    // MARK: - Notifications

    var isPushEnabled: Bool {
        didSet { UserDefaults.standard.set(isPushEnabled, forKey: "owls.settings.push") }
    }

    // MARK: - Language

    var selectedLanguage: OwlsLanguageCode {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "owls.settings.language")
            Task { try? await Container.shared.languageProvider()?.fetchTranslations(for: selectedLanguage) }
            OwlsEventBus.shared.post(.languageChanged)
        }
    }

    // MARK: - Cache

    var cacheSize: String = "Calculating…"

    // MARK: - Environment

    var currentEnvironment: OwlsEnvironment {
        OwlsAppConfig.shared.environment
    }

    // MARK: - Init

    init() {
        isDarkMode = UserDefaults.standard.bool(forKey: "owls.settings.darkMode")
        isPushEnabled = UserDefaults.standard.object(forKey: "owls.settings.push") as? Bool ?? true
        let langRaw = UserDefaults.standard.string(forKey: "owls.settings.language") ?? "en"
        selectedLanguage = OwlsLanguageCode(rawValue: langRaw) ?? .en
    }

    // MARK: - Actions

    func calculateCacheSize() async {
        let bytes = await OwlsImageCache.diskSize
        let mb = Double(bytes) / 1_000_000.0
        cacheSize = String(format: "%.1f MB", mb)
    }

    func clearCache() {
        OwlsImageCache.clearAll()
        OwlsCache.shared.invalidateAll()
        cacheSize = "0 MB"
    }

    func switchEnvironment(_ env: OwlsEnvironment) {
        OwlsAppConfig.shared.setEnvironment(env)
    }
}
