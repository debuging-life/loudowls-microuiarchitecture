import Foundation

// MARK: - Module-Level Feature Flags
// Convention: "module.<modulename>.enabled"

public enum OwlsModuleFlag {

    public static func isModuleEnabled(_ moduleName: String) -> Bool {
        OwlsFeatureFlag.isEnabled("module.\(moduleName).enabled")
    }

    // MARK: - Predefined Module Keys

    public static var isHomeEnabled: Bool { isModuleEnabled("home") }
    public static var isProfileEnabled: Bool { isModuleEnabled("profile") }
    public static var isAuthEnabled: Bool { isModuleEnabled("auth") }
    public static var isStoryLibraryEnabled: Bool { isModuleEnabled("storylibrary") }
    public static var isTransfersEnabled: Bool { isModuleEnabled("transfers") }
}
