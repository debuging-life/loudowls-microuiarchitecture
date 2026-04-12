import SwiftUI
import MicroUICore
import Factory

struct TokenDemoView: View {

    @Injected(\.authTokenProvider) private var authProvider
    @State private var tokenResult: String = "Tap the button to fetch token"
    @State private var isLoading = false

    var body: some View {
        List {
            Section("How Token Sharing Works") {
                VStack(alignment: .leading, spacing: OwlsSpacing.md) {
                    step(1, "AuthMicroUI logs in and registers a LiveAuthTokenProvider into the Factory Container")
                    step(2, "Any module injects @Injected(\\.authTokenProvider) to get the provider")
                    step(3, "The module calls provider.token() to get the current access token")
                    step(4, "If the token is expired, the provider auto-refreshes before returning")
                }
                .padding(.vertical, OwlsSpacing.sm)
            }

            Section("Live Token Test") {
                VStack(alignment: .leading, spacing: OwlsSpacing.md) {
                    Text("This view simulates a different module fetching the token:")
                        .font(OwlsTypography.callout)
                        .foregroundStyle(OwlsColor.secondaryLabel)

                    HStack {
                        Text("Provider Status:")
                            .font(OwlsTypography.headline)
                        Spacer()
                        if authProvider != nil {
                            HStack(spacing: OwlsSpacing.xs) {
                                Circle().fill(.green).frame(width: 8, height: 8)
                                Text("Registered")
                            }
                        } else {
                            HStack(spacing: OwlsSpacing.xs) {
                                Circle().fill(.red).frame(width: 8, height: 8)
                                Text("Not Available")
                            }
                        }
                    }

                    OwlsButton("Fetch Token") {
                        Task { await fetchToken() }
                    }
                    .disabled(isLoading || authProvider == nil)

                    Text(tokenResult)
                        .font(.caption.monospaced())
                        .padding(OwlsSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(OwlsColor.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))
                }
            }

            Section("Code Example") {
                VStack(alignment: .leading, spacing: OwlsSpacing.sm) {
                    Text("In any MicroUI module:")
                        .font(OwlsTypography.caption)
                        .foregroundStyle(OwlsColor.secondaryLabel)

                    Text(codeExample)
                        .font(.caption.monospaced())
                        .padding(OwlsSpacing.md)
                        .background(OwlsColor.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))
                }
            }
        }
        .navigationTitle("Token Demo")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

    private func step(_ number: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: OwlsSpacing.md) {
            Text("\(number)")
                .font(OwlsTypography.caption)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(OwlsColor.primary)
                .clipShape(Circle())

            Text(text)
                .font(OwlsTypography.callout)
        }
    }

    private func fetchToken() async {
        isLoading = true
        tokenResult = "Fetching…"

        do {
            if let token = try await authProvider?.token() {
                tokenResult = "Token: \(token)"
            } else {
                tokenResult = "Error: No auth provider registered"
            }
        } catch {
            tokenResult = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private var codeExample: String {
        """
        @Injected(\\.authTokenProvider)
        private var auth

        func makeAPICall() async throws {
            let token = try await auth?.token()
            // Use token in your URLRequest header:
            // request.setValue("Bearer \\(token)",
            //     forHTTPHeaderField: "Authorization")
        }
        """
    }
}
