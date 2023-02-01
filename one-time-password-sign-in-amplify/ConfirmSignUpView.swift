//
//  ConfirmSignUpView.swift
//  one-time-password-sign-in-amplify
//
//  Created by Kilo Loco on 1/30/23.
//

import Amplify
import SwiftUI

struct ConfirmSignUpView: View {
    
    let username: String
    let didConfirmSignUp: () -> Void
    
    @State var verificationCode: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Image("amplify-logo-large")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TextField("Verification Code", text: $verificationCode)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            
            Button("Confirm Sign Up", action: confirmSignUp)
                .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    func confirmSignUp() {
        Task {
            do {
                let result = try await Amplify.Auth.confirmSignUp(
                    for: username,
                    confirmationCode: verificationCode
                )
                switch result.nextStep {
                case .confirmUser:
                    print("Unexpected next step")
                case .done:
                    print("Sign up finished")
                    didConfirmSignUp()
                }
            } catch {
                print("Failed to confirm sign up", error)
            }
        }
    }
}

struct ConfirmSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSignUpView(username: "kiloloco", didConfirmSignUp: {})
    }
}
