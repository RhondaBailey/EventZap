//
//  AdminLogin.swift
//  EventZap
//
//  Created by Rhonda Bailey on 11/17/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Login") {
                loginButtonTapped()
            }
            .padding()

            // Add additional UI elements as needed
        }
        .padding()
    }

    private func loginButtonTapped() {
        // Validate admin credentials
        if isValidAdmin(username: username, password: password) {
            // Admin login successful - navigate to the main admin view
            // You can use NavigationLink, NavigationView, etc.
        } else {
            // Admin login failed - show an alert or update UI accordingly
        }
    }

    private func isValidAdmin(username: String, password: String) -> Bool {
        // Replace with your admin credentials validation logic
        return username == "admin" && password == "adminPassword"
    }
}
