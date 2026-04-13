import SwiftUI
import MicroUICore

struct AuthMicroUIView: View {

    @State private var viewModel: AuthMicroUIViewModel
    @State private var selectedTab = 0

    init(viewModel: AuthMicroUIViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Header
                VStack(spacing: OwlsSpacing.sm) {
                    OwlsAvatar(.icon("book.and.wrench"), size: .large, backgroundColor: OwlsColor.primary)

                    Text("HooTales")
                        .font(OwlsTypography.largeTitle)

                    Text("Stories for curious minds")
                        .font(OwlsTypography.callout)
                        .foregroundStyle(OwlsColor.secondaryLabel)
                }
                .padding(.top, OwlsSpacing.xxl)
                .padding(.bottom, OwlsSpacing.xl)

                // MARK: Tab Picker
                Picker("", selection: $selectedTab) {
                    Text("Sign In").tag(0)
                    Text("Sign Up").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, OwlsSpacing.lg)

                // MARK: Forms
                ScrollView {
                    VStack(spacing: OwlsSpacing.xl) {
                        if selectedTab == 0 {
                            loginForm
                        } else {
                            signupForm
                        }

                        if let error = viewModel.errorMessage {
                            OwlsAlert(.error, message: error)
                        }
                    }
                    .padding(OwlsSpacing.lg)
                    .padding(.top, OwlsSpacing.md)
                }
            }
            .background(OwlsColor.background)
        }
        .trackScreen("Auth", module: "AuthMicroUI")
    }

    // MARK: - Login Form

    private var loginForm: some View {
        VStack(spacing: OwlsSpacing.lg) {
            OwlsTextField("Username", placeholder: "Enter username (3+ chars)", text: $viewModel.username, textCase: .lowercase)
            OwlsTextField("Password", placeholder: "Enter password (4+ chars)", text: $viewModel.password, isSecure: true)

            OwlsButton("Sign In") {
                Task { await viewModel.login() }
            }
            .disabled(viewModel.isLoading)
            .overlay { if viewModel.isLoading { ProgressView() } }

            OwlsAlert(.info, message: "Demo: any username (3+) and password (4+)")

            // MARK: Social Login Divider
            socialDivider

            AppleSignInButton { userId, email in
                Task { await viewModel.socialLogin(provider: "apple", userId: userId, email: email) }
            } onError: { error in
                viewModel.errorMessage = error
            }

            GoogleSignInButton {
                // TODO: Integrate GoogleSignIn SDK
                viewModel.errorMessage = "Google Sign-In requires GoogleSignIn SDK integration"
            }
        }
    }

    // MARK: - Signup Form

    private var signupForm: some View {
        VStack(spacing: OwlsSpacing.lg) {
            OwlsTextField("Full Name", placeholder: "Enter your name", text: $viewModel.signupName, autocorrection: false)
            OwlsTextField("Email", placeholder: "Enter email", text: $viewModel.signupEmail, keyboardType: .emailAddress, textCase: .lowercase)
            OwlsTextField("Password", placeholder: "Create password (4+ chars)", text: $viewModel.signupPassword, isSecure: true)

            OwlsButton("Create Account") {
                Task { await viewModel.signup() }
            }
            .disabled(viewModel.isLoading)
            .overlay { if viewModel.isLoading { ProgressView() } }

            socialDivider

            AppleSignInButton { userId, email in
                Task { await viewModel.socialLogin(provider: "apple", userId: userId, email: email) }
            } onError: { error in
                viewModel.errorMessage = error
            }
        }
    }

    // MARK: - Divider

    private var socialDivider: some View {
        HStack {
            Rectangle().fill(OwlsColor.secondaryLabel.opacity(0.3)).frame(height: 1)
            Text("or")
                .font(OwlsTypography.caption)
                .foregroundStyle(OwlsColor.secondaryLabel)
            Rectangle().fill(OwlsColor.secondaryLabel.opacity(0.3)).frame(height: 1)
        }
    }
}
