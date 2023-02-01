//
//  LoginView.swift
//  one-time-password-sign-in-amplify
//
//  Created by Kilo Loco on 1/30/23.
//

import Amplify
import AWSCognitoAuthPlugin
import SwiftUI

struct LoginView: View {
    
    let shouldShowSignUp: () -> Void
    let didLogin: () -> Void
    
    @State var username: String = ""
    @State var emailCodeIsVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image("amplify-logo-large")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            
            Button("Login", action: login)
                .buttonStyle(.borderedProminent)
            
            Button(
                "Don't have an account? Sign up.",
                action: shouldShowSignUp
            )
            .padding()
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .sheet(isPresented: $emailCodeIsVisible) {
            EmailCodeView(
                username: username,
                didConfirmLogin: didLogin
            )
        }
        
    }
    
    func login() {
        Task {
            do {
                let options = AWSAuthSignInOptions(authFlowType: .customWithoutSRP)
                let result = try await Amplify.Auth.signIn(
                    username: username.lowercased(),
                    options: .init(pluginOptions: options)
                )
                switch result.nextStep {
                case .confirmSignInWithCustomChallenge(let info):
                    print("User must enter custom challenge. Additonal info: ", info ?? "N/A")
                    emailCodeIsVisible = true
                default:
                    print("Unexpected auth flow. Next step:", result.nextStep)
                }
            } catch {
                print("Failed to login", error)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(shouldShowSignUp: {}, didLogin: {})
    }
}
