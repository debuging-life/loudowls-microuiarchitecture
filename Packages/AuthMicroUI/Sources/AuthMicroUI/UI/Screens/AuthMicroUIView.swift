import SwiftUI
import MicroUICore

struct AuthMicroUIView: View {

    @State private var viewModel: AuthMicroUIViewModel
    @Injected(\.authNavigationCoordinator) private var coordinator
    @State private var path = NavigationPath()

    init(viewModel: AuthMicroUIViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if viewModel.isLoggedIn {
                    loggedInView
                } else {
                    loginForm
                }
            }
            .navigationTitle("Authentication")
            .navigationDestination(for: AuthMicroUIRouter.self) { route in
                route.resolveViewForRoute()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { coordinator.dismiss() }
                }
            }
        }
    }

    // MARK: - Login Form

    private var loginForm: some View {
        ScrollView {
            VStack(spacing: OwlsSpacing.xl) {
                // Header
                VStack(spacing: OwlsSpacing.sm) {
                    OwlsAvatar(.icon("lock.shield"), size: .large, backgroundColor: OwlsColor.primary)

                    Text("Sign In")
                        .font(OwlsTypography.largeTitle)

                    Text("Enter your credentials to authenticate")
                        .font(OwlsTypography.callout)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
                .padding(.top, OwlsSpacing.xxl)

                // Form Fields
                VStack(spacing: OwlsSpacing.lg) {
                    OwlsTextField(
                        "Username",
                        placeholder: "Enter username (min 3 chars)",
                        text: $viewModel.username
                    )

                    OwlsTextField(
                        "Password",
                        placeholder: "Enter password (min 4 chars)",
                        text: $viewModel.password
                    )
                }

                // Error
                if let error = viewModel.errorMessage {
                    OwlsAlert(.error, message: error)
                }

                // Login Button
                OwlsButton("Sign In") {
                    Task { await viewModel.login() }
                }
                .disabled(viewModel.isLoading)
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }

                // Hint
                OwlsAlert(.info, message: "Demo: Use any username (3+ chars) and password (4+ chars)")
            }
            .padding(OwlsSpacing.lg)
        }
    }

    // MARK: - Logged In View

    private var loggedInView: some View {
        List {
            // Token Info
            Section("Active Session") {
                if let token = viewModel.currentToken {
                    LabeledContent("Access Token") {
                        Text(token.accessToken.prefix(20) + "…")
                            .font(.caption.monospaced())
                    }
                    LabeledContent("Refresh Token") {
                        Text(token.refreshToken.prefix(20) + "…")
                            .font(.caption.monospaced())
                    }
                    LabeledContent("Expires") {
                        Text(token.expiresAt, style: .relative)
                    }
                    LabeledContent("Status") {
                        HStack(spacing: OwlsSpacing.xs) {
                            Circle()
                                .fill(token.isExpired ? .red : .green)
                                .frame(width: 8, height: 8)
                            Text(token.isExpired ? "Expired" : "Active")
                        }
                    }
                }
            }

            // Token Demo
            Section("Token Sharing Demo") {
                Button {
                    path.append(AuthMicroUIRouter.tokenDemo)
                } label: {
                    Label("Test Token from Another Module", systemImage: "arrow.triangle.branch")
                }
            }

            // Actions
            Section {
                Button("Refresh Token") {
                    Task { await viewModel.refreshToken() }
                }
                .disabled(viewModel.isLoading)

                Button("Sign Out", role: .destructive) {
                    Task { await viewModel.logout() }
                }
                .disabled(viewModel.isLoading)
            }

            if let error = viewModel.errorMessage {
                Section {
                    OwlsAlert(.error, message: error)
                }
            }
        }
    }
}
