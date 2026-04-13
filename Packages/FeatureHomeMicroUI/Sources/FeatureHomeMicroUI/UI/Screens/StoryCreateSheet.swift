import SwiftUI
import MicroUICore

struct StoryCreateSheet: View {

    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss
    var viewModel: HomeListViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Story Details") {
                    OwlsTextField("Title", placeholder: "Enter story title", text: $title)
                    OwlsTextField("Author", placeholder: "Author name", text: $author)
                }

                Section("Summary") {
                    TextEditor(text: $summary)
                        .frame(minHeight: 100)
                }

                if let error = viewModel.errorMessage {
                    Section {
                        OwlsAlert(.error, message: error)
                    }
                }
            }
            .navigationTitle("New Story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        isSaving = true
                        Task {
                            await viewModel.createStory(title: title, author: author, summary: summary)
                            isSaving = false
                        }
                    }
                    .disabled(title.isEmpty || author.isEmpty || isSaving)
                }
            }
        }
    }
}
