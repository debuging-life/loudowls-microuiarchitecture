#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# create-microui.sh — Scaffold + fully register a MicroUI module
#
# Usage: ./Tools/create-microui.sh [--dry-run] <FeatureName>
# Example: ./Tools/create-microui.sh Transfers
#
# Do NOT include "MicroUI" — it is appended automatically.
# ─────────────────────────────────────────────────────────────

# ─── Colors ──────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ─── Usage ───────────────────────────────────────────────────

usage() {
    echo ""
    echo -e "  ${BOLD}create-microui${NC} — Scaffold a new MicroUI module"
    echo ""
    echo -e "  ${DIM}Usage:${NC}    ./Tools/create-microui.sh [options] <FeatureName>"
    echo ""
    echo -e "  ${DIM}Options:${NC}"
    echo "    --dry-run    Preview changes without writing any files"
    echo "    -h, --help   Show this help message"
    echo ""
    echo -e "  ${DIM}Examples:${NC}"
    echo "    ./Tools/create-microui.sh Transfers"
    echo "    ./Tools/create-microui.sh --dry-run BillPay"
    echo ""
}

# ─── Parse Arguments ─────────────────────────────────────────

DRY_RUN=false
NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift;;
        -h|--help) usage; exit 0;;
        -*) echo -e "${RED}Error:${NC} Unknown option: $1"; usage; exit 1;;
        *)
            if [ -n "$NAME" ]; then
                echo -e "${RED}Error:${NC} Only one feature name allowed."
                exit 1
            fi
            NAME="$1"; shift;;
    esac
done

if [ -z "$NAME" ]; then
    usage
    exit 1
fi

# ─── Validate Name ───────────────────────────────────────────

if [[ ! "$NAME" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    echo -e "${RED}Error:${NC} Feature name must start with uppercase and contain only letters/digits."
    echo "  Got: $NAME"
    echo "  Example: Transfers, BillPay, AccountDetails"
    exit 1
fi

# ─── Derived Names ───────────────────────────────────────────

MODULE="${NAME}MicroUI"
NAME_LOWER=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

# ─── Resolve Paths ───────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PKG_DIR="${PROJECT_ROOT}/Packages/${MODULE}"
SRC_DIR="${PKG_DIR}/Sources/${MODULE}"
CONTAINER_FILE="${PROJECT_ROOT}/Packages/MicroUICore/Sources/MicroUICore/DI/Container+Common.swift"
BOOTSTRAP_FILE="${PROJECT_ROOT}/micruiachitecture/MicroUIBootstrap.swift"
PBXPROJ="${PROJECT_ROOT}/micruiachitecture.xcodeproj/project.pbxproj"

# ─── Pre-flight Checks ──────────────────────────────────────

ERRORS=()

if [ -d "$PKG_DIR" ]; then
    ERRORS+=("Directory ${PKG_DIR} already exists")
fi

if [ ! -f "$CONTAINER_FILE" ]; then
    ERRORS+=("Container+Common.swift not found at expected path")
fi

if [ ! -f "$BOOTSTRAP_FILE" ]; then
    ERRORS+=("MicroUIBootstrap.swift not found at expected path")
fi

if [ ! -f "$PBXPROJ" ]; then
    ERRORS+=("project.pbxproj not found at expected path")
fi

if [ -f "$CONTAINER_FILE" ] && grep -q "${NAME_LOWER}TileBuilder" "$CONTAINER_FILE" 2>/dev/null; then
    ERRORS+=("DI slots for '${NAME_LOWER}' already exist in Container+Common.swift")
fi

if [ -f "$BOOTSTRAP_FILE" ] && grep -q "import ${MODULE}" "$BOOTSTRAP_FILE" 2>/dev/null; then
    ERRORS+=("${MODULE} already imported in MicroUIBootstrap.swift")
fi

if [ ${#ERRORS[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Pre-flight checks failed:${NC}"
    for err in "${ERRORS[@]}"; do
        echo -e "  ${RED}✗${NC} $err"
    done
    echo ""
    exit 1
fi

# ─── Interactive Prompts ─────────────────────────────────────

echo ""
echo -e "${BOLD}Creating MicroUI module: ${CYAN}${MODULE}${NC}"
echo ""

read -p "$(echo -e "  ${YELLOW}Author name${NC} (default: $(git config user.name)): ")" AUTHOR_NAME
AUTHOR_NAME="${AUTHOR_NAME:-$(git config user.name)}"

read -p "$(echo -e "  ${YELLOW}Author email${NC} (default: $(git config user.email)): ")" AUTHOR_EMAIL
AUTHOR_EMAIL="${AUTHOR_EMAIL:-$(git config user.email)}"

read -p "$(echo -e "  ${YELLOW}SF Symbol icon${NC} (default: square.grid.2x2): ")" ICON
ICON="${ICON:-square.grid.2x2}"

read -p "$(echo -e "  ${YELLOW}Tile description${NC} (default: View ${NAME}): ")" TILE_DESC
TILE_DESC="${TILE_DESC:-View ${NAME}}"

echo ""

# ─── Dry Run ─────────────────────────────────────────────────

if $DRY_RUN; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would perform the following:"
    echo ""
    echo -e "  ${CYAN}1.${NC} Create ${PKG_DIR}/"
    echo "     └── Package.swift, Config, Data/, Domain/, UI/"
    echo ""
    echo -e "  ${CYAN}2.${NC} Update Container+Common.swift:"
    echo "     + public var ${NAME_LOWER}TileBuilder: Factory<MicroUITileBuilder?> { promised() }"
    echo "     + public var ${NAME_LOWER}ScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }"
    echo "     + public var ${NAME_LOWER}NavigationCoordinator: Factory<OwlsNavigationCoordinator> { ... }"
    echo ""
    echo -e "  ${CYAN}3.${NC} Update MicroUIBootstrap.swift:"
    echo "     + import ${MODULE}"
    echo "     + ${MODULE}Config()"
    echo ""
    echo -e "  ${CYAN}4.${NC} Update project.pbxproj:"
    echo "     + XCLocalSwiftPackageReference (Packages/${MODULE})"
    echo "     + XCSwiftPackageProductDependency (${MODULE})"
    echo "     + PBXBuildFile + Framework link"
    echo ""
    exit 0
fi

# ═════════════════════════════════════════════════════════════
# STEP 1: Scaffold Module Files
# ═════════════════════════════════════════════════════════════

echo -e "  ${CYAN}[1/4]${NC} Scaffolding module files..."

mkdir -p "${SRC_DIR}/Builder"
mkdir -p "${SRC_DIR}/Data"
mkdir -p "${SRC_DIR}/Domain/Models"
mkdir -p "${SRC_DIR}/Localization"
mkdir -p "${SRC_DIR}/ViewModels"
mkdir -p "${SRC_DIR}/UI/Views"
mkdir -p "${SRC_DIR}/UI/Screens"

# ─── Package.swift ───

cat > "${PKG_DIR}/Package.swift" << EOF
// swift-tools-version: 5.9
// ${MODULE} — Created by ${AUTHOR_NAME} <${AUTHOR_EMAIL}> on $(date +%Y-%m-%d)

import PackageDescription

let package = Package(
    name: "${MODULE}",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "${MODULE}", targets: ["${MODULE}"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "${MODULE}",
            dependencies: ["MicroUICore"]
        )
    ]
)
EOF

# ─── Config ───

cat > "${SRC_DIR}/Builder/${MODULE}Config.swift" << EOF
import MicroUICore
import Factory

public struct ${MODULE}Config: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.${NAME_LOWER}TileBuilder.register {
            ${MODULE}TileBuilder()
        }
        Container.shared.${NAME_LOWER}ScreenBuilder.register {
            ${MODULE}ScreenBuilder()
        }
    }
}
EOF

# ─── Domain Model ───

cat > "${SRC_DIR}/Domain/Models/${NAME}Item.swift" << EOF
import Foundation

struct ${NAME}Item: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let createdAt: Date

    static let mock: [${NAME}Item] = [
        ${NAME}Item(id: "1", title: "Sample ${NAME} 1", subtitle: "Description for item 1", iconName: "star.fill", createdAt: Date()),
        ${NAME}Item(id: "2", title: "Sample ${NAME} 2", subtitle: "Description for item 2", iconName: "heart.fill", createdAt: Date()),
        ${NAME}Item(id: "3", title: "Sample ${NAME} 3", subtitle: "Description for item 3", iconName: "bolt.fill", createdAt: Date()),
    ]
}
EOF

# ─── Localized Strings ───

cat > "${SRC_DIR}/Localization/${NAME}LocalizedString.swift" << EOF
import Foundation
import MicroUICore

// MARK: - ${NAME} Localized Strings
// English values are defined here as comments.
// Other languages are fetched from the server via OwlsLanguageProvider.

enum ${NAME}Strings {

    // MARK: - Screen Titles

    static var screenTitle: String {
        owlsLocalized("${NAME_LOWER}.title", comment: "${NAME}")
    }

    static var detailTitle: String {
        owlsLocalized("${NAME_LOWER}.detail.title", comment: "Details")
    }

    // MARK: - Actions

    static var loadingMessage: String {
        owlsLocalized("${NAME_LOWER}.loading", comment: "Loading ${NAME_LOWER}…")
    }

    static var retryButton: String {
        owlsLocalized("common.retry", comment: "Retry")
    }

    static var closeButton: String {
        owlsLocalized("common.close", comment: "Close")
    }

    static var deleteAction: String {
        owlsLocalized("${NAME_LOWER}.delete", comment: "Delete")
    }

    // MARK: - Empty State

    static var emptyTitle: String {
        owlsLocalized("${NAME_LOWER}.empty.title", comment: "No ${NAME} Yet")
    }

    static var emptyDescription: String {
        owlsLocalized("${NAME_LOWER}.empty.description", comment: "Items will appear here once available.")
    }

    // MARK: - Tile

    static var tileTitle: String {
        owlsLocalized("${NAME_LOWER}.tile.title", comment: "${NAME}")
    }

    static var tileDescription: String {
        owlsLocalized("${NAME_LOWER}.tile.description", comment: "${TILE_DESC}")
    }

    // MARK: - Errors

    static var errorTitle: String {
        owlsLocalized("${NAME_LOWER}.error.title", comment: "Something went wrong")
    }
}
EOF

# ─── DataSource ───

cat > "${SRC_DIR}/Data/${MODULE}DataSource.swift" << EOF
import Foundation
import MicroUICore

protocol ${NAME}DataSource: Sendable {
    func fetchAll() async throws -> [${NAME}Item]
    func fetchDetail(id: String) async throws -> ${NAME}Item
    func create(name: String) async throws -> ${NAME}Item
    func delete(id: String) async throws
}

// MARK: - Mock (returns fake data, simulates network delay)

struct Mock${NAME}DataSource: ${NAME}DataSource {

    func fetchAll() async throws -> [${NAME}Item] {
        try await Task.sleep(for: .milliseconds(500))
        return ${NAME}Item.mock
    }

    func fetchDetail(id: String) async throws -> ${NAME}Item {
        try await Task.sleep(for: .milliseconds(300))
        guard let item = ${NAME}Item.mock.first(where: { \$0.id == id }) else {
            throw OwlsNetworkError.notFound
        }
        return item
    }

    func create(name: String) async throws -> ${NAME}Item {
        try await Task.sleep(for: .milliseconds(400))
        return ${NAME}Item(id: UUID().uuidString, title: name, subtitle: "Newly created", iconName: "plus.circle.fill", createdAt: Date())
    }

    func delete(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Live (swap Mock → Live when API is ready)
//
// final class Live${NAME}DataSource: OwlsBaseService, ${NAME}DataSource {
//     func fetchAll() async throws -> [${NAME}Item] {
//         try await request(${NAME}API.list)
//     }
//     func fetchDetail(id: String) async throws -> ${NAME}Item {
//         try await request(${NAME}API.detail(id: id))
//     }
//     func create(name: String) async throws -> ${NAME}Item {
//         try await request(${NAME}API.create(${NAME}CreateRequest(name: name)))
//     }
//     func delete(id: String) async throws {
//         try await requestVoid(${NAME}API.delete(id: id))
//     }
// }
EOF

# ─── API Routes ───

cat > "${SRC_DIR}/Data/${NAME}API.swift" << EOF
import Foundation
import MicroUICore

enum ${NAME}API: OwlsAPIRoute {

    case list
    case detail(id: String)
    case create(${NAME}CreateRequest)
    case update(id: String, ${NAME}UpdateRequest)
    case delete(id: String)

    // MARK: - Path

    var path: String {
        switch self {
        case .list:
            "/v1/${NAME_LOWER}"
        case .detail(let id):
            "/v1/${NAME_LOWER}/\(id)"
        case .create:
            "/v1/${NAME_LOWER}"
        case .update(let id, _):
            "/v1/${NAME_LOWER}/\(id)"
        case .delete(let id):
            "/v1/${NAME_LOWER}/\(id)"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .list, .detail: .get
        case .create: .post
        case .update: .put
        case .delete: .delete
        }
    }

    // MARK: - Body

    var body: Data? {
        switch self {
        case .create(let payload): Self.encode(payload)
        case .update(_, let payload): Self.encode(payload)
        default: nil
        }
    }
}

// MARK: - Request / Response Models

struct ${NAME}CreateRequest: Encodable, Sendable {
    let name: String
}

struct ${NAME}UpdateRequest: Encodable, Sendable {
    let name: String
}

// MARK: - Live DataSource (swap in when API is ready)
//
// final class Live${NAME}DataSource: OwlsBaseService, ${NAME}DataSource {
//     func fetchData() async throws -> [String] {
//         try await request(${NAME}API.list)
//     }
// }
EOF

# ─── ServiceDispatcher ───

cat > "${SRC_DIR}/Data/${MODULE}ServiceDispatcher.swift" << EOF
import Foundation

struct ${NAME}ServiceDispatcher: Sendable {
    let dataSource: ${NAME}DataSource

    func fetchAll() async throws -> [${NAME}Item] {
        try await dataSource.fetchAll()
    }

    func fetchDetail(id: String) async throws -> ${NAME}Item {
        try await dataSource.fetchDetail(id: id)
    }

    func create(name: String) async throws -> ${NAME}Item {
        try await dataSource.create(name: name)
    }

    func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}
EOF

# ─── Repository ───

cat > "${SRC_DIR}/Domain/${MODULE}Repository.swift" << EOF
import Foundation

protocol ${NAME}Repository: Sendable {
    func loadAll() async throws -> [${NAME}Item]
    func loadDetail(id: String) async throws -> ${NAME}Item
    func create(name: String) async throws -> ${NAME}Item
    func delete(id: String) async throws
}

struct Default${NAME}Repository: ${NAME}Repository {
    private let dispatcher: ${NAME}ServiceDispatcher

    init(dispatcher: ${NAME}ServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadAll() async throws -> [${NAME}Item] {
        try await dispatcher.fetchAll()
    }

    func loadDetail(id: String) async throws -> ${NAME}Item {
        try await dispatcher.fetchDetail(id: id)
    }

    func create(name: String) async throws -> ${NAME}Item {
        try await dispatcher.create(name: name)
    }

    func delete(id: String) async throws {
        try await dispatcher.delete(id: id)
    }
}
EOF

# ─── ViewModel ───

cat > "${SRC_DIR}/ViewModels/${MODULE}ViewModel.swift" << EOF
import Foundation
import Observation

@Observable
final class ${MODULE}ViewModel {

    private(set) var items: [${NAME}Item] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let repository: ${NAME}Repository

    init(repository: ${NAME}Repository) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await repository.loadAll()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func deleteItem(id: String) async {
        do {
            try await repository.delete(id: id)
            items.removeAll { \$0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
EOF

# ─── View ───

cat > "${SRC_DIR}/UI/Screens/${MODULE}View.swift" << EOF
import SwiftUI
import MicroUICore

struct ${MODULE}View: View {

    @State private var viewModel: ${MODULE}ViewModel
    @Injected(\\.${NAME_LOWER}NavigationCoordinator) private var coordinator
    @State private var path = NavigationPath()

    init(viewModel: ${MODULE}ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: \$path) {
            Group {
                if viewModel.isLoading {
                    OwlsLoadingView("Loading ${NAME_LOWER}…")
                } else if let error = viewModel.errorMessage {
                    OwlsEmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Something went wrong",
                        description: error,
                        actionTitle: "Retry"
                    ) { Task { await viewModel.load() } }
                } else if viewModel.items.isEmpty {
                    OwlsEmptyState(
                        icon: "tray",
                        title: "No ${NAME} Yet",
                        description: "Items will appear here once available."
                    )
                } else {
                    itemList
                }
            }
            .navigationTitle("${NAME}")
            .navigationDestination(for: ${MODULE}Router.self) { route in
                route.resolveViewForRoute()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { coordinator.dismiss() }
                }
            }
        }
        .task { await viewModel.load() }
    }

    private var itemList: some View {
        List {
            ForEach(viewModel.items) { item in
                Button {
                    path.append(${MODULE}Router.detail(item))
                } label: {
                    HStack(spacing: OwlsSpacing.md) {
                        Image(systemName: item.iconName)
                            .font(.title3)
                            .foregroundStyle(OwlsColor.primary)
                            .frame(width: 36, height: 36)

                        VStack(alignment: .leading, spacing: OwlsSpacing.xxs) {
                            Text(item.title)
                                .font(OwlsTypography.headline)
                            Text(item.subtitle)
                                .font(OwlsTypography.caption)
                                .foregroundStyle(OwlsColor.secondaryLabel)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(OwlsColor.secondaryLabel)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let item = viewModel.items[index]
                    Task { await viewModel.deleteItem(id: item.id) }
                }
            }
        }
        .listStyle(.plain)
    }
}
EOF

# ─── Tile View ───

cat > "${SRC_DIR}/UI/Views/${NAME}TileView.swift" << EOF
import SwiftUI
import MicroUICore

struct ${NAME}TileView: View {

    @Injected(\\.${NAME_LOWER}NavigationCoordinator) private var coordinator

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                Image(systemName: "${ICON}")
                    .font(.title)
                    .foregroundStyle(OwlsColor.primary)

                Text("${NAME}")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text("${TILE_DESC}")
                    .font(OwlsTypography.caption)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }
            .frame(maxWidth: .infinity)
            .padding(OwlsSpacing.lg)
            .background(OwlsColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
        }
        .buttonStyle(.plain)
    }
}
EOF

# ─── Router ───

cat > "${SRC_DIR}/Builder/${MODULE}Router.swift" << EOF
import SwiftUI
import MicroUICore

enum ${MODULE}Router: OwlsRouter {

    case detail(${NAME}Item)

    var id: String {
        switch self {
        case .detail(let item): "${NAME_LOWER}-detail-\(item.id)"
        }
    }

    @ViewBuilder
    func resolveViewForRoute() -> some View {
        switch self {
        case .detail(let item):
            ${NAME}DetailView(item: item)
        }
    }
}
EOF

# ─── Detail View ───

cat > "${SRC_DIR}/UI/Screens/${NAME}DetailView.swift" << EOF
import SwiftUI
import MicroUICore

struct ${NAME}DetailView: View {

    let item: ${NAME}Item

    var body: some View {
        List {
            Section {
                VStack(spacing: OwlsSpacing.sm) {
                    Image(systemName: item.iconName)
                        .font(.largeTitle)
                        .foregroundStyle(OwlsColor.primary)

                    Text(item.title)
                        .font(OwlsTypography.title)

                    Text(item.subtitle)
                        .font(OwlsTypography.callout)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, OwlsSpacing.lg)
            }

            Section("Details") {
                LabeledContent("ID", value: item.id)
                LabeledContent("Created", value: item.createdAt, format: .dateTime)
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
EOF

# ─── TileBuilder ───

cat > "${SRC_DIR}/Builder/${MODULE}TileBuilder.swift" << EOF
import SwiftUI
import MicroUICore

struct ${MODULE}TileBuilder: MicroUITileBuilder {
    func buildTile() -> AnyView {
        AnyView(${NAME}TileView())
    }
}
EOF

# ─── ScreenBuilder ───

cat > "${SRC_DIR}/Builder/${MODULE}ScreenBuilder.swift" << EOF
import SwiftUI
import MicroUICore
import Factory

struct ${MODULE}ScreenBuilder: MicroUIScreenBuilder {
    func buildScreen() -> AnyView {
        let dataSource = Mock${NAME}DataSource()
        let dispatcher = ${NAME}ServiceDispatcher(dataSource: dataSource)
        let repository = Default${NAME}Repository(dispatcher: dispatcher)
        let viewModel = ${MODULE}ViewModel(repository: repository)
        return AnyView(${MODULE}View(viewModel: viewModel))
    }
}
EOF

# ═════════════════════════════════════════════════════════════
# STEPS 2-4: Auto-register (Container, Bootstrap, Xcode)
# ═════════════════════════════════════════════════════════════

echo -e "  ${CYAN}[2/4]${NC} Registering DI slots in Container+Common.swift..."
echo -e "  ${CYAN}[3/4]${NC} Adding import + config to MicroUIBootstrap.swift..."
echo -e "  ${CYAN}[4/4]${NC} Updating Xcode project.pbxproj..."

python3 - "$MODULE" "$NAME_LOWER" "$CONTAINER_FILE" "$BOOTSTRAP_FILE" "$PBXPROJ" << 'PYEOF'
import sys
import hashlib

module = sys.argv[1]
name_lower = sys.argv[2]
container_path = sys.argv[3]
bootstrap_path = sys.argv[4]
pbxproj_path = sys.argv[5]

def gen_uuid(seed):
    return hashlib.md5(seed.encode()).hexdigest()[:24].upper()

# ─── Container+Common.swift ──────────────────────────────────

with open(container_path, 'r') as f:
    lines = f.read().split('\n')

# Tile builder — insert after last TileBuilder promised() line
last_tile = -1
for i, line in enumerate(lines):
    if 'TileBuilder' in line and 'promised()' in line:
        last_tile = i
if last_tile >= 0:
    lines.insert(last_tile + 1,
        f'    public var {name_lower}TileBuilder: Factory<MicroUITileBuilder?> {{ promised() }}')

# Screen builder — insert after last ScreenBuilder promised() line (re-scan)
last_screen = -1
for i, line in enumerate(lines):
    if 'ScreenBuilder' in line and 'promised()' in line:
        last_screen = i
if last_screen >= 0:
    lines.insert(last_screen + 1,
        f'    public var {name_lower}ScreenBuilder: Factory<MicroUIScreenBuilder?> {{ promised() }}')

# Navigation coordinator — insert after last scope(.shared) + }
last_scope = -1
for i, line in enumerate(lines):
    if 'scope(.shared)' in line:
        last_scope = i
if last_scope >= 0:
    # The "    }" closing the property block is at last_scope + 1
    insert_at = last_scope + 2
    nav_block = [
        '',
        f'    public var {name_lower}NavigationCoordinator: Factory<OwlsNavigationCoordinator> {{',
        f'        self {{ OwlsNavigationCoordinator() }}.scope(.shared)',
        f'    }}',
    ]
    for j, nav_line in enumerate(nav_block):
        lines.insert(insert_at + j, nav_line)

with open(container_path, 'w') as f:
    f.write('\n'.join(lines))

# ─── MicroUIBootstrap.swift ──────────────────────────────────

with open(bootstrap_path, 'r') as f:
    lines = f.read().split('\n')

# Add import after last import line
last_import = -1
for i, line in enumerate(lines):
    if line.startswith('import '):
        last_import = i
if last_import >= 0:
    lines.insert(last_import + 1, f'import {module}')

# Add config to modules array — add comma to current last entry, insert new one before ]
bracket_close = -1
last_config = -1
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped == ']':
        bracket_close = i
        break
    if 'Config()' in stripped:
        last_config = i

if last_config >= 0 and bracket_close >= 0:
    # Add trailing comma if missing
    if not lines[last_config].rstrip().endswith(','):
        lines[last_config] = lines[last_config].rstrip() + ','
    # Insert new config before ]
    indent = '        '
    lines.insert(bracket_close, f'{indent}{module}Config()')

with open(bootstrap_path, 'w') as f:
    f.write('\n'.join(lines))

# ─── project.pbxproj ────────────────────────────────────────

build_uuid = gen_uuid(f'{module}_build')
pkg_ref_uuid = gen_uuid(f'{module}_pkgref')
prod_dep_uuid = gen_uuid(f'{module}_proddep')

with open(pbxproj_path, 'r') as f:
    lines = f.read().split('\n')

# Collect insertion points (line_index, [lines_to_insert])
inserts = []

for i, line in enumerate(lines):

    # 1. PBXBuildFile — before "End PBXBuildFile section"
    if '/* End PBXBuildFile section */' in line:
        inserts.append((i, [
            f'\t\t{build_uuid} /* {module} in Frameworks */ = {{isa = PBXBuildFile; productRef = {prod_dep_uuid} /* {module} */; }};'
        ]))

    # 2. Framework files — after last "in Frameworks" entry
    # (handled below as a special case)

    # 5. XCLocalSwiftPackageReference — before "End" marker
    if '/* End XCLocalSwiftPackageReference section */' in line:
        inserts.append((i, [
            f'\t\t{pkg_ref_uuid} /* XCLocalSwiftPackageReference "Packages/{module}" */ = {{',
            f'\t\t\tisa = XCLocalSwiftPackageReference;',
            f'\t\t\trelativePath = Packages/{module};',
            f'\t\t}};',
        ]))

    # 6. XCSwiftPackageProductDependency — before "End" marker
    if '/* End XCSwiftPackageProductDependency section */' in line:
        inserts.append((i, [
            f'\t\t{prod_dep_uuid} /* {module} */ = {{',
            f'\t\t\tisa = XCSwiftPackageProductDependency;',
            f'\t\t\tproductName = {module};',
            f'\t\t}};',
        ]))

# 2. Framework files — insert after last "in Frameworks" line
last_fw = -1
for i, line in enumerate(lines):
    if 'in Frameworks */' in line:
        last_fw = i
if last_fw >= 0:
    inserts.append((last_fw + 1, [
        f'\t\t\t\t{build_uuid} /* {module} in Frameworks */,'
    ]))

# 3. packageProductDependencies — insert before ); of that array
in_ppd = False
ppd_close = -1
for i, line in enumerate(lines):
    if 'packageProductDependencies' in line and '=' in line:
        in_ppd = True
    if in_ppd and ');' in line.strip():
        ppd_close = i
        in_ppd = False
if ppd_close >= 0:
    inserts.append((ppd_close, [
        f'\t\t\t\t{prod_dep_uuid} /* {module} */,'
    ]))

# 4. packageReferences — insert before ); of that array
in_pr = False
pr_close = -1
for i, line in enumerate(lines):
    if 'packageReferences' in line and '=' in line:
        in_pr = True
    if in_pr and ');' in line.strip():
        pr_close = i
        in_pr = False
if pr_close >= 0:
    inserts.append((pr_close, [
        f'\t\t\t\t{pkg_ref_uuid} /* XCLocalSwiftPackageReference "Packages/{module}" */,'
    ]))

# Apply all insertions from bottom to top so indices stay valid
for line_idx, new_lines in sorted(inserts, key=lambda x: x[0], reverse=True):
    for j, new_line in enumerate(reversed(new_lines)):
        lines.insert(line_idx, new_line)

with open(pbxproj_path, 'w') as f:
    f.write('\n'.join(lines))

PYEOF

# ═════════════════════════════════════════════════════════════
# Done
# ═════════════════════════════════════════════════════════════

echo ""
echo -e "  ${GREEN}✅ ${MODULE} created and fully integrated!${NC}"
echo ""
echo -e "  ${DIM}What was done:${NC}"
echo -e "    ${GREEN}+${NC} Scaffolded ${PKG_DIR}/"
echo -e "    ${GREEN}+${NC} Added DI slots to Container+Common.swift"
echo -e "    ${GREEN}+${NC} Registered in MicroUIBootstrap.swift"
echo -e "    ${GREEN}+${NC} Added package reference to Xcode project"
echo ""
echo -e "  ${BOLD}Just open Xcode and build (⌘B).${NC}"
echo ""
