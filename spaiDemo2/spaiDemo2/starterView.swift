//
//  starterView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/1/24.
//

import SwiftUI

struct starterView: View {
    
    @AppStorage("log_status") var log_Status = false
    @AppStorage("userNickname") var userNickname: String = ""

    var body: some View {
        ZStack {
            if log_Status {
                if userNickname.isEmpty {
                    // If the user is logged in but hasn't set a nickname, show the NicknameView
                    NicknameView { nickname in
                        // This closure is called when the "Continue" button is clicked
                        userNickname = nickname  // Save the nickname
                    }
                } else {
                    // Once the nickname is set, transition to the TabBarView
                    TabBarView()
                }
            } else {
                // If not logged in, show the LoginView
                LoginView()
            }
        }
    }
}

#Preview {
    starterView()
}
