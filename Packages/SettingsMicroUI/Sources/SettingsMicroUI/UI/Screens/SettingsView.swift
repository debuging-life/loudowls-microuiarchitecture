import SwiftUI
import MicroUICore

struct SettingsView: View {

    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                // MARK: Appearance
                Section("Appearance") {
                    Toggle(isOn: $viewModel.isDarkMode) {
                        Label("Dark Mode", systemImage: viewModel.isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .tint(OwlsColor.primary)
                }

                // MARK: Notifications
                Section("Notifications") {
                    Toggle(isOn: $viewModel.isPushEnabled) {
                        Label("Push Notifications", systemImage: "bell.fill")
                    }
                    .tint(OwlsColor.primary)
                }

                // MARK: Language
                Section("Language") {
                    Picker(selection: $viewModel.selectedLanguage) {
                        Text("English").tag(OwlsLanguageCode.en)
                        Text("Spanish").tag(OwlsLanguageCode.es)
                        Text("French").tag(OwlsLanguageCode.fr)
                    } label: {
                        Label("Language", systemImage: "globe")
                    }
                }

                // MARK: Storage
                Section("Storage") {
                    LabeledContent("Image Cache", value: viewModel.cacheSize)

                    Button(role: .destructive) {
                        viewModel.clearCache()
                    } label: {
                        Label("Clear Cache", systemImage: "trash")
                    }
                }

                // MARK: Debug (dev only)
                if viewModel.currentEnvironment.isDebug {
                    Section("Debug") {
                        LabeledContent("Environment", value: viewModel.currentEnvironment.name)
                        LabeledContent("Base URL", value: viewModel.currentEnvironment.baseURL.absoluteString)

                        Picker("Switch Environment", selection: Binding(
                            get: { viewModel.currentEnvironment },
                            set: { viewModel.switchEnvironment($0) }
                        )) {
                            ForEach(OwlsEnvironment.allCases, id: \.self) { env in
                                Text(env.name).tag(env)
                            }
                        }
                    }
                }

                // MARK: About
                Section("About") {
                    LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    LabeledContent("Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                }
            }
            .navigationTitle("Settings")
        }
        .task { await viewModel.calculateCacheSize() }
        .trackScreen("Settings", module: "SettingsMicroUI")
    }
}
