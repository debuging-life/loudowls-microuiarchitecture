import SwiftUI
import MicroUICore

// MARK: - Create Sheet (presented as .sheet from main screen)

struct OwlScreenCreateSheet: View {

    @State private var name = ""
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss
    var viewModel: OwlScreenMicroUIViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("New OwlScreen") {
                    OwlsTextField(
                        "Name",
                        placeholder: "Enter name",
                        text: $name
                    )
                }

                if let error = viewModel.errorMessage {
                    Section {
                        OwlsAlert(.error, message: error)
                    }
                }
            }
            .navigationTitle("Create OwlScreen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        isSaving = true
                        Task {
                            await viewModel.createItem(name: name)
                            isSaving = false
                        }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || isSaving)
                }
            }
        }
    }
}