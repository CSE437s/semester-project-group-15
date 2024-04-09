//
//  LoginViewModel.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/5/24.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var nonce = ""
    @AppStorage("log_status") var log_Status = false
    
    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        // get token
        guard let token = credential.identityToken else {
            print("error with firebase: token1")
            return
        }
        // token string
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with firebase: token2")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString , rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            // user successfully logged in
            print("Login success")
            // direct user to home/dashboard
            withAnimation(.easeInOut) {
                self.log_Status = true
            }
        }
    }
}

// helper from firebase
@available(iOS 13, *)
func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}

// helper from firebase
func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  var randomBytes = [UInt8](repeating: 0, count: length)
  let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
  if errorCode != errSecSuccess {
    fatalError(
      "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
    )
  }

  let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

  let nonce = randomBytes.map { byte in
    // Pick a random character from the set, wrapping around if needed.
    charset[Int(byte) % charset.count]
  }

  return String(nonce)
}

