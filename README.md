# MicroUI Architecture

A production-grade iOS app architecture where each feature is a fully self-contained module. Inspired by how large banking apps structure their codebase at scale.

## Architecture Overview

```
┌──────────────────────────────────────────────────────────┐
│                    App Shell                             │
│  ┌────────────┐  ┌───────────────┐  ┌────────────────┐  │
│  │ Bootstrap   │  │  RootView     │  │  AppRouter     │  │
│  │ (registers  │  │  (TabView +   │  │  (cross-module │  │
│  │  modules)   │  │   Dashboard)  │  │   routing)     │  │
│  └────────────┘  └───────────────┘  └────────────────┘  │
│         │                │                    │          │
│         ▼                ▼                    ▼          │
│  ┌─────────────────────────────────────────────────┐    │
│  │          Factory DI Container                    │    │
│  │  promised() slots for tiles + screens            │    │
│  └─────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────┘
           │                           │
    ┌──────┴──────┐             ┌──────┴──────┐
    ▼             ▼             ▼             ▼
┌────────┐  ┌────────┐    ┌────────┐  ┌────────┐
│ Home   │  │ Home   │    │Profile │  │Profile │
│ Tile   │  │ Screen │    │ Tile   │  │ Screen │
│Builder │  │Builder │    │Builder │  │Builder │
└────────┘  └────────┘    └────────┘  └────────┘
    │            │              │           │
    ▼            ▼              ▼           ▼
┌──────────────────┐    ┌──────────────────────┐
│FeatureHomeMicroUI│    │FeatureProfileMicroUI │
│                  │    │                      │
│ Data/            │    │ Data/                │
│ Domain/          │    │ Domain/              │
│ UI/Views/        │    │ UI/Views/            │
│ UI/Screens/      │    │ UI/Screens/          │
│ UI/Navigation/   │    │ UI/Navigation/       │
└──────────────────┘    └──────────────────────┘
           │                       │
           ▼                       ▼
    ┌─────────────────────────────────┐
    │         MicroUICore             │
    │  Protocols, DI, Design System,  │
    │  Navigation, Extensions         │
    └─────────────────────────────────┘
```

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

## Navigation — Two Layers

### Layer 1: Cross-Module (Shell → Module)

Uses `OwlsNavigationCoordinator` — a simple `@Observable` class with `isPresented: Bool`.

```swift
// Shell presents a module via fullScreenCover
.fullScreenCover(isPresented: Bindable(coordinator).isPresented) {
    screenBuilder?.buildScreen()
}
```

The shell knows nothing about the module's internals. It just asks the builder to produce a view.

### Layer 2: Intra-Module (Screen → Screen)

Uses `NavigationPath` + a typed `OwlsRouter` enum inside each module.

```swift
enum FeatureHomeMicroUIRouter: OwlsRouter {
    case detail(HomeItem)

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            HomeItemDetailView(item: item)
        }
    }
}
```

Each module owns its own `NavigationStack` and routes. Data is passed forward via enum associated values — no string-based routing.

## Factory DI — How It Works

### 1. Declare slots in `Container+Common.swift` (MicroUICore)

```swift
extension Container {
    public var homeTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var homeScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
}
```

`promised()` returns `nil` if the module hasn't registered — safe for feature flags.

### 2. Register in module Config

```swift
public struct FeatureHomeMicroUIConfig: MicroUIRegistration {
    public func registerMicroUI() {
        Container.shared.homeTileBuilder.register {
            FeatureHomeMicroUITileBuilder()
        }
    }
}
```

### 3. Inject anywhere

```swift
@Injected(\.homeTileBuilder) private var homeTileBuilder
```

## Module File Structure

```
FeatureNameMicroUI/
├── Package.swift
└── Sources/FeatureNameMicroUI/
    ├── FeatureNameMicroUIConfig.swift       ← registers into Container
    ├── Data/
    │   ├── FeatureNameMicroUIDataSource.swift
    │   └── FeatureNameMicroUIServiceDispatcher.swift
    ├── Domain/
    │   ├── Models/
    │   │   └── FeatureModel.swift
    │   └── FeatureNameMicroUIRepository.swift
    └── UI/
        ├── Views/
        │   └── FeatureNameTileView.swift     ← dashboard tile
        ├── Screens/
        │   ├── FeatureNameView.swift         ← root screen
        │   └── FeatureNameViewModel.swift
        └── Navigation/
            ├── FeatureNameMicroUITileBuilder.swift
            ├── FeatureNameMicroUIScreenBuilder.swift
            └── FeatureNameMicroUIRouter.swift
```

## Creating a New Module

### Using the CLI

```bash
./Tools/create-microui.sh Transfers
```

This scaffolds `Packages/TransfersMicroUI/` with all boilerplate files.

### Manual Steps After Scaffolding

**1. Add DI slots** in `MicroUICore/Sources/MicroUICore/DI/Container+Common.swift`:

```swift
extension Container {
    public var transfersTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var transfersScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var transfersNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }
}
```

**2. Register in bootstrap** in `micruiachitecture/MicroUIBootstrap.swift`:

```swift
import TransfersMicroUI

// Add to modules array:
TransfersMicroUIConfig(),
```

**3. Add local package in Xcode**:
- File → Add Package Dependencies → Add Local
- Select `Packages/TransfersMicroUI`
- Add `TransfersMicroUI` library to your app target

## Adding a Route Inside an Existing Module

1. Add a case to the module's router enum:

```swift
enum FeatureHomeMicroUIRouter: OwlsRouter {
    case detail(HomeItem)
    case settings          // new route

    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item): HomeItemDetailView(item: item)
        case .settings: HomeSettingsView()
        }
    }
}
```

2. Push from any view inside the module:

```swift
path.append(FeatureHomeMicroUIRouter.settings)
```

## How to Write Tests for a Module

Each module is a standalone SPM package. Add a test target in `Package.swift`:

```swift
.testTarget(
    name: "FeatureHomeMicroUITests",
    dependencies: ["FeatureHomeMicroUI"]
)
```

Test the ViewModel directly by injecting a mock repository:

```swift
struct StubHomeRepository: HomeRepository {
    func loadItems() async throws -> [HomeItem] {
        HomeItem.mock
    }
}

@Test func loadItems() async {
    let vm = HomeListViewModel(repository: StubHomeRepository())
    await vm.loadItems()
    #expect(vm.items.count == 5)
    #expect(vm.errorMessage == nil)
}
```

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

## Tech Stack

- iOS 17.0+
- Swift 5.9+
- SwiftUI
- Swift Package Manager
- Factory 2.x (DI)
- Swift Observation (`@Observable`)
