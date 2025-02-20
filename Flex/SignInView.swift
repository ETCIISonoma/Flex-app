//
//  SignInView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/9/24.
//

/*import SwiftUI
import AuthenticationServices

struct SignInView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.pink)

            VStack(spacing: 10) {
                Text("Sign In")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Text("Sync workouts, trends\nand badges")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 15) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: handleAuthorization
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal, 32.5)

                Button(action: {
                    // Handle passkey login
                }) {
                    HStack {
                        Image(systemName: "person.badge.key.fill").foregroundColor(.pink)
                        Text("Use a passkey").foregroundStyle(.pink)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.15))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                }
                .padding(.horizontal, 32.5)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }

    private func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email

                let identityToken = appleIDCredential.identityToken
                let authorizationCode = appleIDCredential.authorizationCode

                // Convert token and code to string
                let identityTokenString = String(data: identityToken ?? Data(), encoding: .utf8) ?? ""
                let authorizationCodeString = String(data: authorizationCode ?? Data(), encoding: .utf8) ?? ""

                // Create user information dictionary
                let userInformation: [String: Any] = [
                    "user": userIdentifier,
                    "fullName": fullName?.description ?? "",
                    "email": email ?? "",
                    "identityToken": identityTokenString,
                    "authorizationCode": authorizationCodeString
                ]

                // Send this information to your backend for authentication
                authenticateWithBackend(userInformation: userInformation)
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    private func authenticateWithBackend(userInformation: [String: Any]) {
        guard let url = URL(string: "https://your-backend-server.com/authenticate") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInformation, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to authenticate: \(error.localizedDescription)")
                    return
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response from backend: \(responseString)")
                }
            }
            task.resume()
        } catch {
            print("Failed to serialize user information: \(error.localizedDescription)")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}*/

/*import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @AppStorage("fullName") var fullName: String = "Hello"

    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.pink)

            VStack(spacing: 10) {
                Text("Sign In")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Text("Sync workouts, trends\nand badges")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 15) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: handleAuthorization
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal, 32.5)

                Button(action: {
                    // Handle passkey login
                }) {
                    HStack {
                        Image(systemName: "person.badge.key.fill").foregroundColor(.pink)
                        Text("Use a passkey").foregroundStyle(.pink)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.15))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                }
                .padding(.horizontal, 32.5)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }

    private func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email

                let identityToken = appleIDCredential.identityToken
                let authorizationCode = appleIDCredential.authorizationCode

                // Convert token and code to string
                let identityTokenString = String(data: identityToken ?? Data(), encoding: .utf8) ?? ""
                let authorizationCodeString = String(data: authorizationCode ?? Data(), encoding: .utf8) ?? ""

                // Save user's full name
                self.fullName = fullName?.givenName ?? ""

                // Create user information dictionary
                let userInformation: [String: Any] = [
                    "user": userIdentifier,
                    "fullName": fullName?.description ?? "",
                    "email": email ?? "",
                    "identityToken": identityTokenString,
                    "authorizationCode": authorizationCodeString
                ]

                // Send this information to your backend for authentication
                authenticateWithBackend(userInformation: userInformation)
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    private func authenticateWithBackend(userInformation: [String: Any]) {
        guard let url = URL(string: "https://your-backend-server.com/authenticate") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInformation, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to authenticate: \(error.localizedDescription)")
                    return
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response from backend: \(responseString)")
                }
            }
            task.resume()
        } catch {
            print("Failed to serialize user information: \(error.localizedDescription)")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}*/

//
//  SignInView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/9/24.
//

/*import SwiftUI
import AuthenticationServices

struct SignInView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.pink)

            VStack(spacing: 10) {
                Text("Sign In")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Text("Sync workouts, trends\nand badges")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 15) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: handleAuthorization
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal, 32.5)

                Button(action: {
                    // Handle passkey login
                }) {
                    HStack {
                        Image(systemName: "person.badge.key.fill").foregroundColor(.pink)
                        Text("Use a passkey").foregroundStyle(.pink)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.15))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                }
                .padding(.horizontal, 32.5)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }

    private func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email

                let identityToken = appleIDCredential.identityToken
                let authorizationCode = appleIDCredential.authorizationCode

                // Convert token and code to string
                let identityTokenString = String(data: identityToken ?? Data(), encoding: .utf8) ?? ""
                let authorizationCodeString = String(data: authorizationCode ?? Data(), encoding: .utf8) ?? ""

                // Create user information dictionary
                let userInformation: [String: Any] = [
                    "user": userIdentifier,
                    "fullName": fullName?.description ?? "",
                    "email": email ?? "",
                    "identityToken": identityTokenString,
                    "authorizationCode": authorizationCodeString
                ]

                // Send this information to your backend for authentication
                authenticateWithBackend(userInformation: userInformation)
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    private func authenticateWithBackend(userInformation: [String: Any]) {
        guard let url = URL(string: "https://your-backend-server.com/authenticate") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInformation, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to authenticate: \(error.localizedDescription)")
                    return
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response from backend: \(responseString)")
                }
            }
            task.resume()
        } catch {
            print("Failed to serialize user information: \(error.localizedDescription)")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}*/

import SwiftUI
import AuthenticationServices
import CloudKit
import Combine

struct SignInView: View {
    @AppStorage("fullName") var fullName: String = "Hello"
    @EnvironmentObject var wf: workoutFlag
//    @StateObject var vm = UserViewModel()
//    @StateObject var test = WorkoutDataViewModel()
    @State private var isNavigationActive: Bool = false
    
    @ObservedObject var uservm: UserViewModel = UserViewModel.shared
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared


    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.pink)
                
                VStack(spacing: 10) {
                    Text("Sign In")
                        .font(.system(size: 40))
                        .fontWeight(.medium)
                    Text("Sync workouts, trends\nand badges")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button(action: {
                    // Handle passkey login
                    accessorySessionManager.connect()
                    
                    uservm.addUser()
                    // Insert delayed updating logic to check if vm.permissionStatus
//                    test.addItem(workoutCategory: "Full Body & Core", intensityList: [45,35,50])
                    
                    print("\(uservm.userName)")
                    
                    // if vm.permissionStatus {
                    isNavigationActive = true
                    //              accessorySessionManager.writeState(state: 0)
                    
                    // }
                }) {
                    HStack {
                        Image(systemName: "icloud.fill").foregroundColor(.pink)
                        Text("Sign in with iCloud").foregroundStyle(.pink)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink.opacity(0.15))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                }
                .padding(.horizontal, 32.5)
                .padding(.bottom, 50)
                
                NavigationLink(
                    destination: HomeView(),
                    isActive: $isNavigationActive,
                    label: {
                        EmptyView()
                    }
                )
                .isDetailLink(false)
                
                /*
                 VStack(spacing: 15) {
                 SignInWithAppleButton(
                 .signIn,
                 onRequest: { request in
                 request.requestedScopes = [.fullName, .email]
                 },
                 onCompletion: handleAuthorization
                 )
                 .signInWithAppleButtonStyle(.white)
                 .frame(height: 50)
                 .cornerRadius(12)
                 .padding(.horizontal, 32.5)
                 
                 Button(action: {
                 // Handle passkey login
                 }) {
                 HStack {
                 Image(systemName: "person.badge.key.fill").foregroundColor(.pink)
                 Text("Use a passkey").foregroundStyle(.pink)
                 }
                 .frame(maxWidth: .infinity)
                 .padding()
                 .background(Color.pink.opacity(0.15))
                 .foregroundColor(.white)
                 .cornerRadius(12)
                 
                 }
                 .padding(.horizontal, 32.5)
                 }
                 .padding(.bottom, 50)
                 
                 */
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
        }
    }

    private func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email

                let identityToken = appleIDCredential.identityToken
                let authorizationCode = appleIDCredential.authorizationCode

                // Convert token and code to string
                let identityTokenString = String(data: identityToken ?? Data(), encoding: .utf8) ?? ""
                let authorizationCodeString = String(data: authorizationCode ?? Data(), encoding: .utf8) ?? ""

                // Save user's full name
                self.fullName = fullName?.givenName ?? ""

                // Create user information dictionary
                let userInformation: [String: Any] = [
                    "user": userIdentifier,
                    "fullName": fullName?.description ?? "",
                    "email": email ?? "",
                    "identityToken": identityTokenString,
                    "authorizationCode": authorizationCodeString
                ]

                // Send this information to your backend for authentication
                authenticateWithBackend(userInformation: userInformation)
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    private func authenticateWithBackend(userInformation: [String: Any]) {
        guard let url = URL(string: "https://your-backend-server.com/authenticate") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInformation, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to authenticate: \(error.localizedDescription)")
                    return
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response from backend: \(responseString)")
                }
            }
            task.resume()
        } catch {
            print("Failed to serialize user information: \(error.localizedDescription)")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
