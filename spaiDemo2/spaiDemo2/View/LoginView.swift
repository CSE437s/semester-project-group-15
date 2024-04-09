//
//  LoginView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/27/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @StateObject var loginData = LoginViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("SPAI")
                    .font(
                    Font.custom("Roboto", size: 80.7105)
                    .weight(.semibold)
                    )
                    .kerning(0.3067)
                    .multilineTextAlignment(.center)
                    .padding(.top,20)
                    .padding(.leading, 15)
                
                (Text("Welcome,")
                    .foregroundColor(.black) +
                 Text("\nLogin to continue")
                    .foregroundColor(.gray)
                )
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.semibold)
                .lineSpacing(10)
                .padding(.top,20)
                .padding(.trailing,15)
                .padding(.leading, 15)
                .padding(.vertical, 45)
                
                // Apple Login Button
                SignInWithAppleButton { (request) in
                    // requesting parameters from apple login
                    loginData.nonce = randomNonceString()
                    request.requestedScopes = [.email,.fullName]
                    request.nonce = sha256(loginData.nonce)
                    
                } onCompletion: { (result) in
                    // handle error or succesful login
                    switch result {
                    case.success(let user):
                        print("success")
                        // login code
                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                            print("error with firebase")
                            return
                        }
                        loginData.authenticate(credential: credential)
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 55)
                .clipShape(Capsule())
                .padding(.horizontal,30)
                .padding(.vertical, 45)
            }
        }
    }
}

#Preview {
    LoginView()
}
