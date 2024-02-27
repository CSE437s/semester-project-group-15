//
//  NicknameView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/28/24.
//

import SwiftUI

struct NicknameView: View {
    @State private var nickname: String = ""
    var onNicknameSet: (String) -> Void  // Closure to handle nickname setting

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Nickname")
                .font(.title)
                .fontWeight(.bold)

            TextField("Nickname", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !nickname.isEmpty {
                Button(action: {
                    // Call the closure with the new nickname
                    onNicknameSet(nickname)
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: 200)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .transition(.slide)
                .animation(.easeOut, value: nickname)
            }
        }
        .padding()
    }
}

struct NicknameView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameView(onNicknameSet: { _ in })
    }
}


