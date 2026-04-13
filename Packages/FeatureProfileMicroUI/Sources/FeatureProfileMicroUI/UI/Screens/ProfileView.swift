import SwiftUI
import MicroUICore

struct ProfileView: View {

    @State private var viewModel: ProfileViewModel
    @State private var path = NavigationPath()

    init(viewModel: ProfileViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Profile")
                .navigationDestination(for: FeatureProfileMicroUIRouter.self) { route in
                    route.resolveViewForRoute()
                }
        }
        .task { await viewModel.loadProfile() }
        // MARK: Custom Logout Confirmation Dialog
        .owlsSheet(isPresented: $viewModel.isLogoutConfirmPresented, detents: [.medium]) {
            OwlsConfirmationSheet(
                title: "Sign Out",
                message: "Are you sure you want to sign out? You'll need to log in again to access your stories.",
                confirmTitle: "Sign Out",
                confirmRole: .destructive,
                onConfirm: {
                    viewModel.logout()
                },
                onCancel: {
                    viewModel.isLogoutConfirmPresented = false
                }
            )
        }
        .trackScreen("Profile", module: "FeatureProfileMicroUI")
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            OwlsLoadingView("Loading profile…")
        } else if let profile = viewModel.profile {
            profileContent(profile)
        } else if let error = viewModel.errorMessage {
            OwlsEmptyState(
                icon: "exclamationmark.triangle",
                title: "Something went wrong",
                description: error,
                actionTitle: "Retry"
            ) { Task { await viewModel.loadProfile() } }
        }
    }

    private func profileContent(_ profile: UserProfile) -> some View {
        List {
            // MARK: Avatar
            Section {
                VStack(spacing: OwlsSpacing.sm) {
                    OwlsAvatar(.initials(profile.avatarInitials), size: .large)

                    Text("\(profile.firstName) \(profile.lastName)")
                        .font(OwlsTypography.title)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, OwlsSpacing.md)
            }

            // MARK: Contact Info
            Section("Contact Info") {
                LabeledContent("Email", value: profile.email)
                LabeledContent("Phone", value: profile.phone)
            }

            // MARK: Edit Profile — push navigation
            Section {
                Button {
                    path.append(FeatureProfileMicroUIRouter.editProfile(profile))
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
            }

            // MARK: Logout — custom confirmation sheet
            Section {
                Button(role: .destructive) {
                    viewModel.isLogoutConfirmPresented = true
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.red)
                }
            }
        }
    }
}
