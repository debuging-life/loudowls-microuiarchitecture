import SwiftUI
import MicroUICore

struct EditProfileView: View {

    @State private var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss

    init(profile: UserProfile, repository: ProfileRepository) {
        _viewModel = State(initialValue: EditProfileViewModel(profile: profile, repository: repository))
    }

    var body: some View {
        Form {
            Section("Name") {
                TextField("First Name", text: $viewModel.firstName)
                TextField("Last Name", text: $viewModel.lastName)
            }

            Section("Contact") {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                TextField("Phone", text: $viewModel.phone)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }

            if let error = viewModel.errorMessage {
                Section {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(OwlsTypography.caption)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        if await viewModel.save() {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.hasChanges || viewModel.isSaving)
            }
        }
    }
}
