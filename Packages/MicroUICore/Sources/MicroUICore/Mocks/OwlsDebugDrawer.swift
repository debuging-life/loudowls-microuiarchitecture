import SwiftUI

// MARK: - Debug Drawer

public struct OwlsDebugDrawer: View {

    @State private var registry = OwlsMockRegistry.shared
    @State private var searchQuery = ""
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                // MARK: Environment Section
                environmentSection

                // MARK: Mocks by Module
                ForEach(filteredModules, id: \.self) { module in
                    moduleSection(module: module)
                }

                // MARK: Reset Section
                resetSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("🐛 Debug Drawer")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search mocks…")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .bold()
                }
            }
        }
    }

    // MARK: - Environment Section

    private var environmentSection: some View {
        Section("Environment") {
            HStack {
                Image(systemName: "server.rack")
                    .foregroundStyle(OwlsColor.primary)
                Text("Current")
                Spacer()
                Text(OwlsAppConfig.shared.environment.name)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }

            Picker("Switch", selection: Binding(
                get: { OwlsAppConfig.shared.environment },
                set: { OwlsAppConfig.shared.setEnvironment($0) }
            )) {
                ForEach(OwlsEnvironment.allCases, id: \.self) { env in
                    Text(env.name).tag(env)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Module Section

    private func moduleSection(module: String) -> some View {
        let mocks = filteredMocks(for: module)
        return Section {
            ForEach(mocks) { mock in
                MockToggleRow(mock: mock, registry: registry)
            }
        } header: {
            HStack {
                Image(systemName: iconForModule(module))
                    .foregroundStyle(OwlsColor.primary)
                Text(displayName(module))
                    .font(.caption.bold())
                Spacer()
                if let activeCount = activeCount(in: mocks), activeCount > 0 {
                    Text("\(activeCount) active")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(OwlsColor.primary.opacity(0.15))
                        .foregroundStyle(OwlsColor.primary)
                        .clipShape(Capsule())
                }
            }
        }
    }

    // MARK: - Reset

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                registry.disableAll()
            } label: {
                Label("Disable All Mocks", systemImage: "arrow.counterclockwise.circle")
            }
            .disabled(registry.enabledMockIds.isEmpty)
        } footer: {
            Text("Real APIs will be called when no mocks are enabled.")
        }
    }

    // MARK: - Helpers

    private var filteredModules: [String] {
        let modules = registry.allMocks().keys.sorted()
        guard !searchQuery.isEmpty else { return modules }
        return modules.filter { !filteredMocks(for: $0).isEmpty }
    }

    private func filteredMocks(for module: String) -> [OwlsMockItem] {
        let all = registry.allMocks()[module] ?? []
        guard !searchQuery.isEmpty else { return all }
        let q = searchQuery.lowercased()
        return all.filter {
            $0.name.lowercased().contains(q)
            || $0.endpoint.lowercased().contains(q)
            || module.lowercased().contains(q)
        }
    }

    private func activeCount(in mocks: [OwlsMockItem]) -> Int? {
        mocks.filter { registry.isEnabled($0.id) }.count
    }

    private func displayName(_ module: String) -> String {
        module.replacingOccurrences(of: "MicroUI", with: "").uppercased()
    }

    private func iconForModule(_ module: String) -> String {
        if module.contains("Home") || module.contains("Story") { return "book.fill" }
        if module.contains("Auth") { return "lock.fill" }
        if module.contains("Profile") { return "person.fill" }
        if module.contains("Settings") { return "gearshape.fill" }
        if module.contains("Favorite") { return "heart.fill" }
        if module.contains("Onboarding") { return "sparkles" }
        return "square.stack.fill"
    }
}

// MARK: - Mock Toggle Row

private struct MockToggleRow: View {
    let mock: OwlsMockItem
    var registry: OwlsMockRegistry

    var body: some View {
        Toggle(isOn: Binding(
            get: { registry.isEnabled(mock.id) },
            set: { registry.setEnabled(mock.id, enabled: $0) }
        )) {
            HStack(spacing: 8) {
                categoryBadge

                VStack(alignment: .leading, spacing: 2) {
                    Text(mock.name)
                        .font(.body)
                        .lineLimit(1)
                    Text("\(mock.method.rawValue) \(mock.endpoint)")
                        .font(.caption2.monospaced())
                        .foregroundStyle(OwlsColor.secondaryLabel)
                        .lineLimit(1)
                }
            }
        }
        .tint(OwlsColor.primary)
    }

    private var categoryBadge: some View {
        Text(mock.category.rawValue)
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(badgeColor.opacity(0.15))
            .foregroundStyle(badgeColor)
            .clipShape(Capsule())
    }

    private var badgeColor: Color {
        switch mock.category {
        case .success: .green
        case .empty: .blue
        case .failure: .red
        case .edgeCase: .orange
        }
    }
}

// MARK: - Floating Debug Button

public struct OwlsDebugButton: View {

    @State private var isDrawerPresented = false
    @State private var registry = OwlsMockRegistry.shared

    public init() {}

    public var body: some View {
        Button {
            isDrawerPresented = true
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "ladybug.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(OwlsColor.primary)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 8, y: 3)

                if !registry.enabledMockIds.isEmpty {
                    Text("\(registry.enabledMockIds.count)")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .frame(minWidth: 18, minHeight: 18)
                        .padding(.horizontal, 4)
                        .background(.red)
                        .clipShape(Capsule())
                        .offset(x: 4, y: -4)
                }
            }
        }
        .padding()
        .sheet(isPresented: $isDrawerPresented) {
            OwlsDebugDrawer()
        }
    }
}
