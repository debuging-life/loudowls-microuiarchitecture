import SwiftUI
import AuthenticationServices
import MicroUICore

// MARK: - Apple Sign In Button

struct AppleSignInButton: View {

    let onSuccess: (String, String) -> Void  // (userId, email)
    let onError: (String) -> Void

    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                handleAppleAuth(auth)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
    }

    private func handleAppleAuth(_ authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            onError("Invalid Apple credential")
            return
        }

        let userId = credential.user
        let email = credential.email ?? "\(userId.prefix(8))@apple.id"

        OwlsAnalytics.track(.buttonTapped("Apple Sign In", screen: "Auth"))
        onSuccess(userId, email)
    }
}

// MARK: - Google Sign In Button (UI placeholder — needs GoogleSignIn SDK)

struct GoogleSignInButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: OwlsSpacing.md) {
                Image(systemName: "g.circle.fill")
                    .font(.title2)
                Text("Sign in with Google")
                    .font(OwlsTypography.headline)
            }
            .foregroundStyle(OwlsColor.label)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(OwlsColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: OwlsRadius.lg)
                    .stroke(OwlsColor.secondaryLabel.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
