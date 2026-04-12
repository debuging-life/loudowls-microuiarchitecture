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
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading profile…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let profile = viewModel.profile {
            profileContent(profile)
        } else if let error = viewModel.errorMessage {
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(error)
            )
        }
    }

    private func profileContent(_ profile: UserProfile) -> some View {
        List {
            // MARK: Avatar Section
            Section {
                VStack(spacing: OwlsSpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(OwlsColor.primary)
                            .frame(width: 80, height: 80)
                        Text(profile.avatarInitials)
                            .font(OwlsTypography.title)
                            .foregroundStyle(.white)
                    }

                    Text("\(profile.firstName) \(profile.lastName)")
                        .font(OwlsTypography.title)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, OwlsSpacing.md)
            }

            // MARK: Info Section
            Section("Contact Info") {
                LabeledContent("Email", value: profile.email)
                LabeledContent("Phone", value: profile.phone)
            }

            // MARK: Edit
            Section {
                Button {
                    path.append(FeatureProfileMicroUIRouter.editProfile(profile))
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
            }
        }
    }
}
