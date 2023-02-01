//
//  one_time_password_sign_in_amplifyApp.swift
//  one-time-password-sign-in-amplify
//
//  Created by Kilo Loco on 1/30/23.
//

import Amplify
import AWSCognitoAuthPlugin
import SwiftUI

@main
struct one_time_password_sign_in_amplifyApp: App {
    
    init() {
        configureAmplify()
        Task {
            _ = await Amplify.Auth.signOut()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Successfully configured Amplify")
        } catch {
            print("Failed to initialize Amplify:", error)
        }
    }
}
