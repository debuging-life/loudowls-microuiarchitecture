# MicroUI Architecture (HooTales)

A production-grade iOS app architecture where each feature is a fully self-contained module. Inspired by how large banking apps structure their codebase at scale.

This repo is the **reference implementation** built around a children's storytelling app called **HooTales**. It demonstrates every pattern with real, working modules.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Module Rules](#module-rules)
3. [Module File Structure](#module-file-structure)
4. [Default Modules (Demo App)](#default-modules-demo-app)
5. [Creating a New Module — `owls-microui`](#creating-a-new-module)
6. [Running a Module Independently (Example apps)](#running-a-module-independently)
7. [Navigation](#navigation)
7. [Factory DI](#factory-di)
8. [Network Layer (BaseService + APIRoute)](#network-layer)
9. [Mock Data System / Debug Drawer](#mock-data-system--debug-drawer)
10. [Auth Token Sharing](#auth-token-sharing)
11. [Analytics](#analytics)
12. [Deep Linking](#deep-linking)
13. [Push Notifications](#push-notifications)
14. [Feature Flags](#feature-flags)
15. [Event Bus](#event-bus)
16. [Localization](#localization)
17. [Logging](#logging)
18. [Caching](#caching)
19. [Pagination](#pagination)
20. [Error Handler](#error-handler)
21. [Security](#security)
22. [Environment Config](#environment-config)
23. [Image Loading (Kingfisher)](#image-loading)
24. [ReusableUI Components](#reusableui-components)
25. [Dark Mode](#dark-mode)
26. [Testing](#testing)
27. [Project Conventions](#project-conventions)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         App Shell                               │
│  ┌────────────┐  ┌──────────────┐  ┌────────────┐  ┌────────┐  │
│  │ Bootstrap   │  │  RootView    │  │ DeepLink   │  │ Feature│  │
│  │ (registers  │  │  (Auth gate +│  │ Router     │  │ Flags  │  │
│  │  modules)   │  │  TabView)    │  │            │  │        │  │
│  └────────────┘  └──────────────┘  └────────────┘  └────────┘  │
│         │                │                │              │      │
│         ▼                ▼                ▼              ▼      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Factory DI Container                       │   │
│  │  promised() slots for tiles, screens, providers         │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
           │              │               │              │
    ┌──────┘      ┌───────┘       ┌───────┘      ┌──────┘
    ▼             ▼               ▼              ▼
┌────────┐  ┌────────┐    ┌──────────┐    ┌────────┐
│ Home   │  │Profile │    │   Auth   │    │ Story  │
│MicroUI │  │MicroUI │    │ MicroUI  │    │Library │
└────────┘  └────────┘    └──────────┘    └────────┘
    │            │              │              │
    └────────────┴──────────────┴──────────────┘
                         │
                         ▼
         ┌───────────────────────────────────┐
         │         MicroUICore               │
         │                                   │
         │  Protocols    Network             │
         │  DI           Mocks (Debug Drawer)│
         │  Navigation   Analytics           │
         │  DesignSystem DeepLink            │
         │  ReusableUI   FeatureFlags        │
         │  Localization EventBus            │
         │  Logging      Cache               │
         │  Security     Pagination          │
         │  ErrorHandler Config (Env)        │
         │  Notifications                    │
         └───────────────────────────────────┘
```

---

## Module Rules

```
✅ Module CAN import MicroUICore
✅ Module CAN import Factory (re-exported by MicroUICore)
✅ Module CAN import Kingfisher (re-exported by MicroUICore)
✅ Module CAN have its own models, networking, state

❌ Module CANNOT import another module
❌ Module CANNOT know about the main app
❌ Module CANNOT use global singletons outside Factory Container
❌ Module CANNOT use CocoaPods
```

---

## Module File Structure

```
FeatureNameMicroUI/
├── Package.swift                          ← resources include Mocks/JSON
├── Sources/FeatureNameMicroUI/
│   ├── Builder/
│   │   ├── Config.swift                   ← registers tile + screen + mocks
│   │   ├── Router.swift                   ← typed OwlsRouter enum
│   │   ├── TileBuilder.swift              ← embeddable widget
│   │   ├── ScreenBuilder.swift            ← full screen
│   │   └── DeepLinkHandler.swift          ← URL routing
│   ├── Data/
│   │   ├── FeatureNameAPI.swift           ← API routes (OwlsAPIRoute)
│   │   ├── DataSource.swift               ← live + mock implementations
│   │   └── ServiceDispatcher.swift
│   ├── Domain/
│   │   ├── Models/
│   │   └── Repository.swift
│   ├── Localization/
│   │   └── LocalizedString.swift          ← English keys
│   ├── Mocks/
│   │   ├── MockProvider.swift             ← lists mocks (route + JSON)
│   │   └── JSON/
│   │       ├── nameSuccess.json
│   │       ├── nameEmpty.json
│   │       └── nameFailure.json
│   ├── ViewModels/
│   └── UI/
│       ├── Screens/                       ← list, detail, create sheet
│       └── Views/                         ← tile views
└── Tests/FeatureNameMicroUITests/
    └── ViewModelTests.swift               ← starter test cases
```

---

## Default Modules (Demo App)

The repo ships with 8 modules demonstrating the architecture:

| Module | Purpose |
|---|---|
| **AuthMicroUI** | Login/Signup forms + Apple Sign In + token persistence |
| **OnboardingMicroUI** | 3-page first-launch walkthrough |
| **FeatureHomeMicroUI** | Story feed with pagination, sheet, fullscreen reader |
| **FeatureProfileMicroUI** | Profile + Edit + Logout with custom confirmation |
| **SettingsMicroUI** | Dark mode, language, cache, env switcher |
| **FavoriteScreenMicroUI** | Favorites list (CLI-generated example) |
| **OwlScreenMicroUI** | Generic CRUD module (CLI-generated example) |
| **OwlAboutMicroUI** | Generic info module (CLI-generated example) |

**App flow:**
```
First Launch → Onboarding (3 pages) → "Get Started"
    ↓
Auth Screen (Login/Signup + Apple Sign In)
    ↓ (login → registers token, persists to Keychain)
TabView
├── Stories (paginated list, create sheet, fullscreen reader)
├── Profile (edit, logout with confirmation)
└── Settings (dark mode, language, cache, env switcher)
```

---

## Creating a New Module

### Install the CLI (one time)

```bash
brew install debuging-life/owls-cli/owls-microui
```

### Create a module

```bash
owls-microui create Transfers
```

**Interactive prompts:**
- Author name & email
- SF Symbol icon
- Tile description

**What it does automatically:**
1. Scaffolds `Packages/TransfersMicroUI/` with full structure
2. Generates `TransfersAPI` route enum (CRUD endpoints)
3. Generates `TransfersMockProvider` + 3 sample JSONs
4. Generates `TransfersLocalizedString` with English keys
5. Generates test target with starter tests
6. Adds DI slots to `Container+Common.swift`
7. Adds import + config to `MicroUIBootstrap.swift`
8. Updates `project.pbxproj` (package reference + framework link)

### Remove a module

```bash
owls-microui remove Transfers
```

**[Full CLI docs →](https://github.com/debuging-life/homebrew-owls-cli)**

---

## Running a Module Independently

Every module ships with its own self-contained iOS app inside `Example/`. Open the project, hit ⌘R, and **just that module** launches — no main app, no login, no other modules. Inspired by the `pod lib create` Example folder pattern banks use.

### Quick start

```bash
# Open just the Home module
open Packages/FeatureHomeMicroUI/Example/HomeExampleApp.xcodeproj

# Hit ⌘R — Stories list appears with mock data
```

### Why this matters

| Use case | How Example apps help |
|---|---|
| **UI iteration** | Designer/dev tweaks one screen without launching the full app stack |
| **Pure isolation** | Verify the module works without unstated dependencies |
| **Faster compile** | Only the focused module + MicroUICore compile |
| **Bug reproduction** | "Does it repro in just this module?" → open Example app |
| **Designer review** | Hand a designer the Example xcodeproj — they don't need the whole codebase |

### Architecture: how it stays clean

The "no module imports another module" rule stays intact. The Example app is a **host** (just like the main app):

```
Module source code (pure):
  Sources/FeatureHomeMicroUI/...
  └── only imports MicroUICore

Example app (host):
  Example/HomeExampleApp/...
  └── imports MicroUICore + this module
  └── registers stubs for cross-module DI slots
```

When `Home` module's view embeds `profileTileBuilder`, the Example app registers a stub:

```swift
Container.shared.profileTileBuilder.register {
    OwlsStubTileBuilder(label: "Profile Tile")
}
```

The stub renders a dashed-border placeholder so the focused module's UI still composes correctly.

### Two modes per Example app

**1. Stub mode (default)** — fully isolated. Cross-module slots return placeholder views.

**2. Integration mode (opt-in)** — to test how Module A renders Module B's *real* tile:
- Add Module B's SPM package to the Example xcodeproj's dependencies
- Uncomment the `import` and registration block in `ExampleBootstrap.swift`

### Folder structure

```
Packages/FeatureHomeMicroUI/
├── Package.swift
├── Sources/...                              ← module code (pure)
├── Example/                                 ← sandbox app
│   ├── HomeExampleApp.xcodeproj
│   └── HomeExampleApp/
│       ├── HomeExampleApp.swift             ← @main entry
│       ├── ExampleBootstrap.swift           ← DI + stubs + mock toggles
│       └── Assets.xcassets/
└── Tests/...
```

### Available Example apps

| Module | Open |
|---|---|
| Stories (Home) | `Packages/FeatureHomeMicroUI/Example/HomeExampleApp.xcodeproj` |
| Auth | `Packages/AuthMicroUI/Example/AuthExampleApp.xcodeproj` |
| Profile | `Packages/FeatureProfileMicroUI/Example/ProfileExampleApp.xcodeproj` |
| Settings | `Packages/SettingsMicroUI/Example/SettingsExampleApp.xcodeproj` |

New modules created via `owls-microui create` get an Example app automatically. Pass `--no-sandbox` to skip.

### How modules use other modules (without breaking the rule)

Modules **never** import each other directly. Communication goes through Container slots:

```swift
// In Module A's view — accesses Module B's tile widget without knowing about it
@Injected(\.profileTileBuilder) private var profileTile

var body: some View {
    HStack {
        Text("Featured by")
        profileTile?.buildTile()   // Returns AnyView from Profile module
    }
}
```

In the main app: real `FeatureProfileMicroUITileBuilder` is registered → real view renders.
In the Home Example app: `OwlsStubTileBuilder(label: "Profile Tile")` is registered → placeholder renders.

The module's source code is identical in both cases. The host decides what to register.

---

## Navigation

### Layer 1: Cross-Module (Shell → Module)

`OwlsNavigationCoordinator` with `present()` and `dismiss()`:

```swift
.fullScreenCover(isPresented: Bindable(coordinator).isPresented) {
    screenBuilder?.buildScreen()
}

// Or as sheet:
coordinator.present(style: .sheet)

// With data:
coordinator.present(style: .fullScreen, data: ["itemId": "123"])
let id: String? = coordinator.value(for: "itemId")
```

### Layer 2: Intra-Module (Screen → Screen)

Typed `OwlsRouter` enum with `NavigationStack`:

```swift
enum FeatureHomeMicroUIRouter: OwlsRouter {
    case detail(Story)

    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let story): StoryDetailView(story: story)
        }
    }
}

// Push:
path.append(FeatureHomeMicroUIRouter.detail(story))
```

### Auth Gate (RootView)

Listens to `OwlsEventBus` for login/logout events to swap between auth screen and TabView:

```swift
@Observable
final class AppAuthState {
    var isLoggedIn = false

    init() {
        OwlsEventBus.shared.on("user.logged_in") { _ in self.isLoggedIn = true }
        OwlsEventBus.shared.on("user.logged_out") { _ in self.isLoggedIn = false }
    }
}
```

---

## Factory DI

```swift
// 1. Declare slot in MicroUICore (Container+Common.swift)
extension Container {
    public var homeScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
}

// 2. Module registers in Config
Container.shared.homeScreenBuilder.register {
    FeatureHomeMicroUIScreenBuilder()
}

// 3. Inject anywhere
@Injected(\.homeScreenBuilder) private var homeScreenBuilder
```

---

## Network Layer

### OwlsAPIRoute — Module-Owned Routes

```swift
enum HomeAPI: OwlsAPIRoute {
    case list(page: Int, limit: Int)
    case detail(id: String)
    case create(title: String, author: String, summary: String)

    var path: String {
        switch self {
        case .list, .create: "/v1/home"
        case .detail(let id): "/v1/home/\(id)"
        }
    }

    var method: HTTPMethod { ... }
    var queryItems: [URLQueryItem]? { ... }
    var body: Data? { ... }
}
```

### OwlsBaseService

```swift
final class LiveHomeDataSource: OwlsBaseService, HomeDataSource {
    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        try await request(HomeAPI.list(page: page, limit: limit))
    }
}
```

**On every request:**
1. **Mock interception (DEBUG only)** — see Mock Data System below
2. `OwlsLoggingInterceptor` logs `[Network] GET /v1/home`
3. `OwlsAuthInterceptor` injects `Bearer <token>`
4. URLComponents builds URL from route
5. Auto-retry on 401 after token refresh
6. Decodes with snake_case + ISO8601

---

## Mock Data System / Debug Drawer

The killer feature for fast iteration. **Frontend ships UI without waiting for backend.**

### How it works

```
1. Each module registers an OwlsMockProvider listing 3 mocks per endpoint:
   - Success (200, sample data)
   - Empty (200, [])
   - Failure (500, error JSON)

2. In DEBUG, a floating 🐛 button appears bottom-right.

3. Tapping the button opens the Debug Drawer:
   - Search across all mocks
   - Toggle per mock
   - Grouped by module
   - Active count badges

4. When a mock is enabled, OwlsBaseService.request() detects it
   and returns the JSON instead of hitting the network.

5. In RELEASE, all mock code is stripped (#if DEBUG).
```

### Defining a mock provider

```swift
public struct FeatureHomeMicroUIMockProvider: OwlsMockProvider {

    public var moduleName: String { "FeatureHomeMicroUI" }

    public func mockItems() -> [OwlsMockItem] {
        // Reference the API route — endpoint/method come from HomeAPI
        let listRoute = HomeAPI.list(page: 1, limit: 1)

        return [
            OwlsMockItem(
                id: "home.stories.success",
                name: "Stories — Success (3 items)",
                module: moduleName,
                route: listRoute,
                jsonFilename: "storiesSuccess.json",
                bundle: .module,
                statusCode: 200,
                category: .success
            ),
            // ... empty + failure
        ]
    }
}
```

### Registering in Config

```swift
public func registerMicroUI() {
    Container.shared.homeScreenBuilder.register { ... }

    #if DEBUG
    OwlsMockRegistry.shared.register(FeatureHomeMicroUIMockProvider())
    #endif
}
```

### Package.swift resource configuration

```swift
.target(
    name: "FeatureHomeMicroUI",
    dependencies: ["MicroUICore"],
    resources: [.process("Mocks/JSON")]   // ← bundles JSON files
)
```

### Auto-enable defaults on first launch (optional)

In `MicroUIBootstrap.swift`:
```swift
private static func enableDefaultMocksIfNeeded() {
    #if DEBUG
    let key = "owls.mocks.defaultsEnabled"
    guard !UserDefaults.standard.bool(forKey: key) else { return }
    OwlsMockRegistry.shared.setEnabled("home.stories.success", enabled: true)
    UserDefaults.standard.set(true, forKey: key)
    #endif
}
```

---

## Auth Token Sharing

```swift
// AuthMicroUI logs in → registers provider + persists to Keychain
Container.shared.authTokenProvider.register { LiveAuthTokenProvider(token) }
OwlsKeychain.shared.save(token.accessToken, forKey: .accessToken)

// Any module — inject and use:
@Injected(\.authTokenProvider) private var auth
let token = try await auth?.token()    // auto-refreshes if expired

// Logout
Container.shared.authTokenProvider.register { nil }
OwlsKeychain.shared.delete(.accessToken)
OwlsEventBus.shared.post(.userLoggedOut)
```

### Apple Sign In

```swift
AppleSignInButton { userId, email in
    Task { await viewModel.socialLogin(provider: "apple", userId: userId, email: email) }
} onError: { error in
    viewModel.errorMessage = error
}
```

### Session Restore

`MicroUIBootstrap.restoreSession()` reads tokens from Keychain on app launch and re-registers the provider. Login state survives app restarts.

---

## Analytics

```swift
// App shell registers providers at boot:
Container.shared.analyticsProviders.register {
    [ConsoleAnalyticsProvider(), FirebaseAnalyticsProvider()]
}

// Any module fires events:
OwlsAnalytics.track(.screenViewed("StoryDetail", module: "Home"))
OwlsAnalytics.track(.buttonTapped("Purchase", screen: "Subscription"))
OwlsAnalytics.track(.errorOccurred("Load failed", module: "Home", screen: "List"))

// SwiftUI modifier:
.trackScreen("StoryList", module: "FeatureHomeMicroUI")
```

---

## Deep Linking

URL format: `owlsapp://module/path?key=value`

```swift
// 1. App receives URL
.onOpenURL { url in
    OwlsDeepLinkRouter.shared.route(url: url)
}

// 2. Module's DeepLinkHandler (registered in Config)
struct FeatureHomeMicroUIDeepLinkHandler: OwlsDeepLinkHandler {
    var supportedModules: [String] { ["home"] }

    func handle(_ deepLink: OwlsDeepLink) -> Bool {
        let coordinator = Container.shared.homeNavigationCoordinator()
        coordinator.present(style: .fullScreen, data: ["path": deepLink.path])
        return true
    }
}
```

Push notifications also route through this:
```swift
OwlsDeepLinkRouter.shared.route(userInfo: notification.userInfo)
```

---

## Push Notifications

```swift
// AppDelegate handles registration + delivery
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, didFinishLaunchingWithOptions: ...) -> Bool {
        Task { await OwlsPushNotificationManager.shared.requestPermission() }
        app.registerForRemoteNotifications()
        return true
    }

    func application(_ app: UIApplication, didReceiveRemoteNotification userInfo: ...) async -> UIBackgroundFetchResult {
        OwlsPushNotificationManager.shared.handleNotification(userInfo: userInfo)
        return .newData
    }
}
```

### Testing in Simulator

```bash
xcrun simctl push booted aap.loudowls.micruiachitecture TestPayloads/story_notification.apns
```

Or drag the `.apns` file onto the Simulator window.

Push payload format:
```json
{
    "aps": { "alert": { "title": "...", "body": "..." } },
    "module": "home",
    "path": "detail/123"
}
```

---

## Feature Flags

```swift
// App fetches at boot (non-blocking)
Task { try? await provider.fetchFlags() }
// GET /api/feature-flags → {"module.home.enabled": true, ...}

// Module-level checks:
if OwlsModuleFlag.isHomeEnabled { showTile() }

// Custom flags:
if OwlsFeatureFlag.isEnabled("feature.dark_mode") { ... }
let max: Int = OwlsFeatureFlag.value("max_retry_count", defaultValue: 3)
```

---

## Event Bus

```swift
// Post:
OwlsEventBus.shared.post(.userLoggedOut)

// Listen:
let sub = OwlsEventBus.shared.on("user.logged_out") { _ in
    OwlsCache.shared.invalidate(prefix: "home.")
}
sub.cancel()
```

### Built-in events

| Event | Fired When |
|---|---|
| `.userLoggedIn` / `.userLoggedOut` | Auth flow |
| `.tokenRefreshed` | Token auto-refreshed |
| `.languageChanged` | User switches language |
| `.themeChanged` | Dark/light toggle |
| `.cacheCleared` | Cache invalidated |

---

## Localization

Module defines **English keys**. Other languages come from server.

```swift
enum HomeStrings {
    static var screenTitle: String {
        owlsLocalized("home.title", comment: "Stories")
    }
}

// Switch language:
let provider = Container.shared.languageProvider()
await provider?.fetchTranslations(for: .es)
// GET /api/translations?lang=es → all owlsLocalized() calls return Spanish
```

Missing translations fall back to the English `comment` value.

---

## Logging

```swift
OwlsLogger.debug("...", module: "Home")
OwlsLogger.info("Fetched 42 items", module: "Home")
OwlsLogger.warning("Cache miss", module: "Home")
OwlsLogger.error("Failed to load", module: "Home", error: error)
OwlsLogger.critical("Database corrupted", module: "Home")
```

Output (DEBUG):
```
🔍 [Home] ... (HomeListView.swift:45)
ℹ️ [Home] Fetched 42 items (HomeListViewModel.swift:32)
❌ [Home] Failed to load | Network error (HomeListViewModel.swift:38)
```

`error` and `critical` levels auto-forward to Analytics.

---

## Caching

```swift
// Get or fetch with TTL (default 5 min)
let stories: [Story] = try await OwlsCache.shared.get("stories") {
    try await service.fetchStories()
}

// Invalidate
OwlsCache.shared.invalidate("stories")
OwlsCache.shared.invalidate(prefix: "home.")
OwlsCache.shared.invalidateAll()    // posts .cacheCleared event
```

---

## Pagination

```swift
// In ViewModel
let paginator = OwlsPaginator<Story>(pageSize: 10) { page, size in
    try await repository.loadStories(page: page, limit: size)
}

// In View
List(paginator.items) { story in
    StoryRow(story: story)
        .task { await paginator.loadNextPageIfNeeded(currentItem: story) }
}
.task { await paginator.loadFirstPage() }
.refreshable { await paginator.refresh() }
```

States: `.idle / .loading / .loadingMore / .loaded / .empty / .error`

---

## Error Handler

```swift
// Any module — catch + handle globally
do {
    try await service.fetchStories()
} catch {
    OwlsErrorHandler.shared.handle(error, module: "Home", screen: "List")
}

// App shell shows alert automatically
RootView()
    .owlsErrorAlert()
```

401 errors auto-trigger logout. All errors logged + tracked in Analytics.

---

## Security

### Keychain

```swift
OwlsKeychain.shared.save(token, forKey: .accessToken)
let token = OwlsKeychain.shared.string(forKey: .accessToken)
OwlsKeychain.shared.delete(.accessToken)
```

Stored with `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` — encrypted, no iCloud backup.

### Certificate Pinning

```swift
let session = URLSession.owlsPinned(hashes: ["sha256-hash-1", "sha256-hash-2"])
let service = MyService(session: session)
```

Bypassed in DEBUG builds for proxy tools (Charles, Proxyman).

---

## Environment Config

```swift
// Auto-detects: DEBUG → .dev, RELEASE → .prod
OwlsAppConfig.shared.environment   // .dev / .staging / .prod

// Switch (updates base URL + fires event)
OwlsAppConfig.shared.setEnvironment(.staging)

// Per-env URLs
.dev     → https://dev-api.example.com
.staging → https://staging-api.example.com
.prod    → https://api.example.com
```

Switch from Settings tab in DEBUG builds.

---

## Image Loading

Powered by **Kingfisher** (re-exported by MicroUICore).

```swift
OwlsRemoteImage(urlString: "https://...", placeholder: "photo")

// Or
OwlsRemoteImage(url: URL(...), size: CGSize(width: 200, height: 200))

// Configure cache
OwlsImageCache.configure(
    memoryLimit: 100 * 1024 * 1024,   // 100 MB
    diskLimit: 500 * 1024 * 1024,      // 500 MB
    diskExpiration: .days(7)
)

// Clear (e.g. from Settings)
OwlsImageCache.clearAll()
```

Built-in retry, fade-in, placeholder, memory + disk cache.

---

## ReusableUI Components

All available via `import MicroUICore`:

| Component | Usage |
|---|---|
| `OwlsButton` | `.primary`, `.secondary`, `.destructive` variants |
| `OwlsCard` | Card wrapper with shadow/rounded corners |
| `OwlsTextField` | With `isSecure`, `textCase`, validation states |
| `OwlsAvatar` | `.initials("PB")`, `.icon("person")`, sizes |
| `OwlsBadge` | `.count(3)` or `.dot`; `.owlsBadge(3)` modifier |
| `OwlsSheet` | `.owlsSheet(isPresented:)` with detents |
| `OwlsConfirmationSheet` | Custom confirm/cancel dialog (used for logout) |
| `OwlsLoadingView` | Spinner + skeleton row + shimmer |
| `OwlsEmptyState` | Icon + title + description + optional CTA |
| `OwlsAlert` | `.info`, `.success`, `.warning`, `.error` banners |
| `OwlsAppearance` | Global nav/tab bar appearance config |
| `OwlsRemoteImage` | Async image loading via Kingfisher |
| `OwlsDebugDrawer` | Mock + env switcher (DEBUG only) |
| `OwlsDebugButton` | Floating 🐛 launcher (DEBUG only) |

### Design tokens

```swift
OwlsColor.primary       // #5FA052 (HooTales green)
OwlsColor.secondary     // #040506
OwlsColor.background / .secondaryBackground / .label / .secondaryLabel

OwlsSpacing.xxs / .xs / .sm / .md / .lg / .xl / .xxl / .xxxl
OwlsRadius.sm / .md / .lg / .xl / .pill
OwlsTypography.largeTitle / .title / .headline / .body / .callout / .caption
```

---

## Dark Mode

```swift
@AppStorage("owls.settings.darkMode") private var isDarkMode = false

RootView()
    .preferredColorScheme(isDarkMode ? .dark : .light)
```

Toggle via Settings tab. Posts `.themeChanged` event so modules can react.

---

## Testing

Every CLI-generated module includes a test target:

```swift
@Suite("FeatureHomeMicroUI ViewModel Tests")
struct HomeListViewModelTests {

    struct StubRepository: HomeRepository {
        var shouldFail = false
        func loadStories(page: Int, limit: Int) async throws -> [Story] {
            if shouldFail { throw TestError.mockFailure }
            return Story.mock
        }
        // ...
    }

    @Test("Load stories successfully")
    func loadStories() async {
        let vm = HomeListViewModel(repository: StubRepository())
        await vm.paginator.loadFirstPage()
        #expect(!vm.paginator.items.isEmpty)
    }
}
```

Run: `swift test --package-path Packages/FeatureHomeMicroUI`

---

## Project Conventions

| Convention | Rule |
|---|---|
| DI Framework | Factory 2.x only |
| Navigation | Typed OwlsRouter enums, no string routes |
| State Management | `@Observable` (Swift Observation) |
| Async | `async/await` only, no completion handlers |
| Access Control | `private` by default, `public` at module boundary |
| Force Unwrap | Never in production code |
| AnyView | Only at tile/screen builder boundaries |
| File Organization | `// MARK: -` sections in every file |
| ViewModel Size | Split if exceeding 150 lines |
| Package Manager | SPM only, no CocoaPods |
| Localization | English keys in code, translations from server |
| Logging | `OwlsLogger` only, no raw `print()` in production |
| API Routes | Typed enums conforming to `OwlsAPIRoute` |
| Caching | `OwlsCache` with TTL, no manual dictionaries |
| Secrets | `OwlsKeychain` only, never UserDefaults |
| Mocks | Reference `route:` from API enum (single source of truth) |
| Image Loading | `OwlsRemoteImage` only, no raw `AsyncImage` |

---

## Tech Stack

- iOS 17.0+
- Swift 5.9+ / Swift 6 strict concurrency
- SwiftUI
- Swift Package Manager
- Factory 2.x (DI)
- Kingfisher 8.x (image loading)
- Swift Observation (`@Observable`)
- os.Logger (structured logging)
- CryptoKit (certificate pinning)
- AuthenticationServices (Apple Sign In)
- UserNotifications (push)

---

## MicroUICore Infrastructure Map

```
MicroUICore/Sources/MicroUICore/
├── Analytics/          ← multi-provider event tracking
├── Auth/               ← AuthTokenProvider protocol
├── Cache/              ← in-memory TTL cache
├── Config/             ← OwlsEnvironment (dev/staging/prod)
├── DeepLink/           ← URL + push routing
├── DesignSystem/       ← colors, typography, spacing, radius
├── DI/                 ← Factory Container slots
├── ErrorHandling/      ← OwlsErrorHandler + .owlsErrorAlert()
├── EventBus/           ← module-to-module pub/sub
├── Extensions/         ← View + Color extensions
├── FeatureFlags/       ← server-driven flag checks
├── Localization/       ← server-driven translations
├── Logging/            ← unified logger
├── Mocks/              ← Mock data system + Debug Drawer
├── Navigation/         ← OwlsNavigationCoordinator
├── Network/            ← BaseService, APIRoute, interceptors
├── Notifications/      ← Push notification manager
├── Pagination/         ← OwlsPaginator + paginated list view
├── Protocols/          ← MicroUI protocols
├── ReusableUI/         ← shared UI components
└── Security/           ← Keychain wrapper, certificate pinning
```

---

## Related Repos

- **CLI Tool:** [debuging-life/homebrew-owls-cli](https://github.com/debuging-life/homebrew-owls-cli) — `owls-microui` binary distributed via Homebrew
