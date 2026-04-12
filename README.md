# MicroUI Architecture

A production-grade iOS app architecture where each feature is a fully self-contained module. Inspired by how large banking apps structure their codebase at scale.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         App Shell                               │
│  ┌────────────┐  ┌──────────────┐  ┌────────────┐  ┌────────┐  │
│  │ Bootstrap   │  │  RootView    │  │ DeepLink   │  │ Feature│  │
│  │ (registers  │  │  (TabView +  │  │ Router     │  │ Flags  │  │
│  │  modules)   │  │  Dashboard)  │  │            │  │        │  │
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
         ┌───────────────────────────────┐
         │         MicroUICore           │
         │                               │
         │  Protocols    Network         │
         │  DI           Analytics       │
         │  Navigation   DeepLink        │
         │  DesignSystem FeatureFlags    │
         │  ReusableUI   EventBus        │
         │  Localization Logging         │
         │  Security     Cache           │
         └───────────────────────────────┘
```

---

## Table of Contents

1. [Module Rules](#module-rules)
2. [Module File Structure](#module-file-structure)
3. [Creating a New Module (CLI)](#creating-a-new-module)
4. [Navigation](#navigation)
5. [Factory DI](#factory-di)
6. [Network Layer (BaseService + APIRoute)](#network-layer)
7. [Auth Token Sharing](#auth-token-sharing)
8. [Analytics](#analytics)
9. [Deep Linking](#deep-linking)
10. [Feature Flags](#feature-flags)
11. [Event Bus](#event-bus)
12. [Localization](#localization)
13. [Logging](#logging)
14. [Caching](#caching)
15. [Security](#security)
16. [ReusableUI Components](#reusableui-components)
17. [Testing](#testing)
18. [Project Conventions](#project-conventions)

---

## Module Rules

```
 Module CAN import MicroUICore
 Module CAN import Factory (re-exported by MicroUICore)
 Module CAN have its own models, networking, state

 Module CANNOT import another module
 Module CANNOT know about the main app
 Module CANNOT use global singletons outside Factory Container
 Module CANNOT use CocoaPods
```

---

## Module File Structure

```
FeatureNameMicroUI/
├── Package.swift
├── Sources/FeatureNameMicroUI/
│   ├── Builder/
│   │   ├── FeatureNameMicroUIConfig.swift         ← registers into Container
│   │   ├── FeatureNameMicroUIRouter.swift          ← typed route enum
│   │   ├── FeatureNameMicroUITileBuilder.swift     ← dashboard tile builder
│   │   └── FeatureNameMicroUIScreenBuilder.swift   ← full screen builder
│   ├── Data/
│   │   ├── FeatureNameAPI.swift                    ← API route enum (OwlsAPIRoute)
│   │   ├── FeatureNameMicroUIDataSource.swift      ← mock + live data sources
│   │   └── FeatureNameMicroUIServiceDispatcher.swift
│   ├── Domain/
│   │   ├── Models/
│   │   │   └── FeatureNameItem.swift
│   │   └── FeatureNameMicroUIRepository.swift
│   ├── Localization/
│   │   └── FeatureNameLocalizedString.swift        ← English keys only
│   ├── ViewModels/
│   │   └── FeatureNameMicroUIViewModel.swift
│   └── UI/
│       ├── Screens/
│       │   ├── FeatureNameMicroUIView.swift
│       │   └── FeatureNameDetailView.swift
│       └── Views/
│           └── FeatureNameTileView.swift
└── Tests/FeatureNameMicroUITests/
    └── FeatureNameMicroUIViewModelTests.swift      ← auto-generated tests
```

---

## Creating a New Module

### One Command — Zero Manual Steps

```bash
./Tools/create-microui.sh Transfers
```

**Interactive prompts:**
- Author name & email
- SF Symbol icon for the tile
- Tile description text

**What it does automatically:**
1. Scaffolds `Packages/TransfersMicroUI/` with all files
2. Generates `TransfersAPI` route enum with CRUD operations
3. Generates `TransfersLocalizedString` with English keys
4. Generates test target with 3 starter tests
5. Adds DI slots to `Container+Common.swift`
6. Adds import + config to `MicroUIBootstrap.swift`
7. Updates `project.pbxproj` (package reference + framework link)

**Additional options:**
```bash
./Tools/create-microui.sh --dry-run BillPay    # preview without writing
./Tools/create-microui.sh -h                    # help
```

---

## Navigation

### Layer 1: Cross-Module (Shell -> Module)

Uses `OwlsNavigationCoordinator` with `isPresented: Bool`.

```swift
.fullScreenCover(isPresented: Bindable(coordinator).isPresented) {
    screenBuilder?.buildScreen()
}
```

The shell knows nothing about the module's internals.

### Layer 2: Intra-Module (Screen -> Screen)

Uses `NavigationPath` + typed `OwlsRouter` enum.

```swift
enum FeatureHomeMicroUIRouter: OwlsRouter {
    case detail(HomeItem)

    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item): HomeItemDetailView(item: item)
        }
    }
}

// Push:
path.append(FeatureHomeMicroUIRouter.detail(item))
```

---

## Factory DI

### 1. Declare slots (MicroUICore)

```swift
extension Container {
    public var homeTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var homeScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
}
```

### 2. Register (Module Config)

```swift
Container.shared.homeTileBuilder.register {
    FeatureHomeMicroUITileBuilder()
}
```

### 3. Inject (Any View)

```swift
@Injected(\.homeTileBuilder) private var homeTileBuilder
```

`promised()` returns `nil` if unregistered — safe for feature flags.

---

## Network Layer

### OwlsAPIRoute — Each Module Defines Its Own Routes

```swift
enum StoryAPI: OwlsAPIRoute {
    case list
    case detail(id: String)
    case create(StoryCreateRequest)

    var path: String {
        switch self {
        case .list: "/v1/stories"
        case .detail(let id): "/v1/stories/\(id)"
        case .create: "/v1/stories"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .detail: .get
        case .create: .post
        }
    }

    var body: Data? {
        switch self {
        case .create(let payload): Self.encode(payload)
        default: nil
        }
    }
}
```

### OwlsBaseService — Subclass and Call Routes

```swift
final class LiveStoryDataSource: OwlsBaseService, StoryDataSource {
    func fetchStories() async throws -> [Story] {
        try await request(StoryAPI.list)
    }
}
```

**What happens automatically on every request:**
1. `OwlsLoggingInterceptor` logs `[Network] GET /v1/stories`
2. `OwlsAuthInterceptor` injects `Bearer <token>` from Container
3. URLComponents builds URL from route (scheme, host, path, query)
4. Response: status code check, auto-retry on 401 after token refresh
5. Decode with snake_case + ISO8601

---

## Auth Token Sharing

```swift
// AuthMicroUI logs in → registers provider
Container.shared.authTokenProvider.register { LiveAuthTokenProvider(token) }

// Any module — inject and use:
@Injected(\.authTokenProvider) private var auth
let token = try await auth?.token()
// Token auto-refreshes if expired

// User logs out → provider cleared
Container.shared.authTokenProvider.register { nil }
```

Modules never import AuthMicroUI — they only depend on the `AuthTokenProvider` protocol in MicroUICore.

---

## Analytics

### Multi-Provider Architecture

```swift
// App shell registers providers at boot:
Container.shared.analyticsProviders.register {
    [ConsoleAnalyticsProvider(), FirebaseAnalyticsProvider()]
}

// Any module fires events:
OwlsAnalytics.track(.screenViewed("StoryDetail", module: "StoryLibrary"))
OwlsAnalytics.track(.buttonTapped("Purchase", screen: "Subscription"))
OwlsAnalytics.track(.errorOccurred("Load failed", module: "Home", screen: "List"))

// SwiftUI view modifier:
.trackScreen("StoryDetail", module: "StoryLibrary")
```

### Built-in Event Types

| Builder | Parameters |
|---|---|
| `.screenViewed(name, module)` | Screen view tracking |
| `.buttonTapped(name, screen)` | User interaction |
| `.apiCalled(endpoint, success, duration)` | Network monitoring |
| `.errorOccurred(error, module, screen)` | Error tracking |
| `.appLifecycle(state)` | Foreground/background |

---

## Deep Linking

### URL Format

```
owlsapp://storylibrary/detail/123?tab=reviews
```

### How It Works

```swift
// 1. App receives URL
.onOpenURL { url in
    OwlsDeepLinkRouter.shared.route(url: url)
}

// 2. Module registers a handler (in Config)
OwlsDeepLinkRouter.shared.register(StoryLibraryDeepLinkHandler())

// 3. Handler routes to the correct screen
struct StoryLibraryDeepLinkHandler: OwlsDeepLinkHandler {
    var supportedModules: [String] { ["storylibrary"] }

    func handle(_ deepLink: OwlsDeepLink) -> Bool {
        let id = deepLink.path  // "detail/123"
        coordinator.present()
        return true
    }
}
```

Also supports push notifications:
```swift
OwlsDeepLinkRouter.shared.route(userInfo: notification.userInfo)
```

---

## Feature Flags

### Server-Driven Flags

```swift
// App fetches flags at boot:
await featureFlagProvider.fetchFlags()
// GET /api/feature-flags → {"module.storylibrary.enabled": true, ...}

// Module-level checks:
if OwlsModuleFlag.isStoryLibraryEnabled { showTile() }

// Custom flags:
if OwlsFeatureFlag.isEnabled("feature.dark_mode") { ... }
let maxRetries: Int = OwlsFeatureFlag.value("max_retry_count", defaultValue: 3)
```

### How It Integrates with DI

When a module's flag is disabled, its `promised()` slot stays unregistered. The tile builder returns `nil`, so the tile doesn't appear on the dashboard. No crashes, no `if/else` in the UI.

---

## Event Bus

### Module-to-Module Communication

```swift
// AuthMicroUI posts when user logs out:
OwlsEventBus.shared.post(.userLoggedOut)

// HomeMicroUI listens and clears its cache:
let sub = OwlsEventBus.shared.on("user.logged_out") { _ in
    OwlsCache.shared.invalidate(prefix: "home.")
}

// Cancel subscription when done:
sub.cancel()
```

### Built-in Events

| Event | Fired When |
|---|---|
| `.userLoggedIn` | Auth completes login |
| `.userLoggedOut` | Auth completes logout |
| `.tokenRefreshed` | Token auto-refreshed |
| `.languageChanged` | User switches language |
| `.themeChanged` | Dark/light mode toggle |
| `.cacheCleared` | Cache invalidated |

---

## Localization

### Server-Driven Translations

Modules only define **English keys**. Other languages come from the server.

```swift
// Module defines keys (Localization/StoryLibraryLocalizedString.swift)
enum StoryLibraryStrings {
    static var screenTitle: String {
        owlsLocalized("storylibrary.title", comment: "Story Library")
    }
    static var emptyTitle: String {
        owlsLocalized("storylibrary.empty.title", comment: "No Stories Yet")
    }
}

// Usage in view:
.navigationTitle(StoryLibraryStrings.screenTitle)
```

### How Translation Resolution Works

```
English (default):
  comment: "Story Library" → returns "Story Library"

Spanish (after server fetch):
  key: "storylibrary.title" → looks up translations → "Biblioteca"

Missing translation:
  key not in server response → falls back to comment → "Story Library"
```

### Switching Language

```swift
let provider = Container.shared.languageProvider()
await provider?.fetchTranslations(for: .es)
// GET /api/translations?lang=es
// All owlsLocalized() calls now return Spanish
```

---

## Logging

### Unified Logger with os.Logger

```swift
OwlsLogger.debug("Loading stories", module: "StoryLibrary")
OwlsLogger.info("Fetched 42 items", module: "StoryLibrary")
OwlsLogger.warning("Cache miss", module: "StoryLibrary")
OwlsLogger.error("Failed to load", module: "StoryLibrary", error: error)
OwlsLogger.critical("Database corrupted", module: "StoryLibrary")
```

**Output (DEBUG):**
```
🔍 [StoryLibrary] Loading stories (StoryListView.swift:45)
ℹ️ [StoryLibrary] Fetched 42 items (StoryListViewModel.swift:32)
⚠️ [StoryLibrary] Cache miss (StoryService.swift:18)
❌ [StoryLibrary] Failed to load | Network error (StoryListViewModel.swift:38)
```

Errors (level >= .error) are automatically forwarded to Analytics.

---

## Caching

### In-Memory Cache with TTL

```swift
// Get or fetch (caches for 5 minutes by default):
let stories: [Story] = try await OwlsCache.shared.get("stories") {
    try await service.fetchStories()  // only calls API if cache is stale
}

// Custom TTL:
let profile = try await OwlsCache.shared.get("profile", ttl: 600) {
    try await service.fetchProfile()
}

// Invalidate:
OwlsCache.shared.invalidate("stories")             // single key
OwlsCache.shared.invalidate(prefix: "home.")        // all home keys
OwlsCache.shared.invalidateAll()                    // everything
```

On `invalidateAll()`, the event bus posts `.cacheCleared` so modules can react.

---

## Security

### Keychain Wrapper

```swift
// Save
OwlsKeychain.shared.save(token, forKey: .accessToken)

// Read
let token = OwlsKeychain.shared.string(forKey: .accessToken)

// Delete
OwlsKeychain.shared.delete(.accessToken)

// Check
if OwlsKeychain.shared.exists(.refreshToken) { ... }
```

Data stored with `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` — encrypted at rest, available after first unlock, not backed up to iCloud.

### Certificate Pinning

```swift
// Create a pinned URLSession:
let session = URLSession.owlsPinned(hashes: [
    "abc123...",  // primary cert hash
    "def456...",  // backup cert hash
])

// Use in BaseService:
let service = MyService(session: session)
```

SHA256 hash of the server certificate. Pinning is bypassed in DEBUG builds for proxy tools (Charles, Proxyman).

---

## ReusableUI Components

All available via `import MicroUICore`:

| Component | Usage |
|---|---|
| `OwlsButton` | `.primary`, `.secondary`, `.destructive` variants |
| `OwlsCard` | Card wrapper with shadow and rounded corners |
| `OwlsTextField` | Input with `.idle`, `.valid`, `.invalid("msg")` states |
| `OwlsAvatar` | `.initials("PB")`, `.icon("person")` in `.small/.medium/.large` |
| `OwlsBadge` | `.count(3)` or `.dot` with `.owlsBadge(3)` view modifier |
| `OwlsSheet` | `.owlsSheet(isPresented:)` with detents |
| `OwlsConfirmationSheet` | Title + message + confirm/cancel |
| `OwlsLoadingView` | Spinner with optional message |
| `OwlsSkeletonRow` | Shimmer loading placeholder |
| `OwlsEmptyState` | Icon + title + description + optional CTA |
| `OwlsAlert` | `.info`, `.success`, `.warning`, `.error` banners |
| `OwlsAppearance` | Global nav/tab bar appearance config |

### Design Tokens

```swift
OwlsColor.primary / .secondary / .label / .secondaryLabel / .background
OwlsSpacing.xs / .sm / .md / .lg / .xl / .xxl
OwlsRadius.sm / .md / .lg / .xl / .pill
OwlsTypography.largeTitle / .title / .headline / .body / .callout / .caption
```

---

## Testing

Every module generated by the CLI includes a test target with starter tests.

```swift
@Suite("StoryLibraryMicroUI ViewModel Tests")
struct StoryLibraryMicroUIViewModelTests {

    struct StubRepository: StoryLibraryRepository {
        var shouldFail = false
        func loadAll() async throws -> [StoryLibraryItem] {
            if shouldFail { throw TestError.mockFailure }
            return StoryLibraryItem.mock
        }
        // ...
    }

    @Test("Load items successfully")
    func loadItems() async {
        let vm = StoryLibraryMicroUIViewModel(repository: StubRepository())
        await vm.load()
        #expect(vm.items.count == 3)
        #expect(vm.errorMessage == nil)
    }

    @Test("Load failure shows error")
    func loadFailure() async {
        let vm = StoryLibraryMicroUIViewModel(repository: StubRepository(shouldFail: true))
        await vm.load()
        #expect(vm.items.isEmpty)
        #expect(vm.errorMessage != nil)
    }
}
```

Run tests: `swift test --package-path Packages/StoryLibraryMicroUI`

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

---

## Tech Stack

- iOS 17.0+
- Swift 5.9+ / Swift 6 strict concurrency
- SwiftUI
- Swift Package Manager
- Factory 2.x (DI)
- Swift Observation (`@Observable`)
- os.Logger (structured logging)
- CryptoKit (certificate pinning)

---

## MicroUICore Infrastructure Map

```
MicroUICore/Sources/MicroUICore/
├── Analytics/          ← event tracking, multi-provider
├── Auth/               ← AuthTokenProvider protocol
├── Cache/              ← in-memory TTL cache
├── DeepLink/           ← URL + push notification routing
├── DesignSystem/       ← colors, typography, spacing, radius
├── DI/                 ← Factory Container slots
├── EventBus/           ← module-to-module pub/sub
├── Extensions/         ← View extensions
├── FeatureFlags/       ← server-driven flag checks
├── Localization/       ← server-driven translations
├── Logging/            ← unified logger (os.Logger + analytics)
├── Navigation/         ← OwlsNavigationCoordinator
├── Network/            ← BaseService, APIRoute, interceptors, errors
├── Protocols/          ← MicroUI protocols (TileBuilder, ScreenBuilder, Router)
├── ReusableUI/         ← shared UI components
└── Security/           ← Keychain wrapper, certificate pinning
```
