//
//  SettingsView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @AppStorage("log_status") var log_Status = false
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    // sign out
                    DispatchQueue.global(qos: .background).async {
                        try? Auth.auth().signOut()
                    }
                    // back to login
                    withAnimation(.easeInOut) {
                        log_Status = false
                    }
                    
                }, label: {
                    Text ("Log Out")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(width: UIScreen.main.bounds .width / 2)
                        .background(Color.red)
                        .clipShape(Capsule())
                })
                
                
                Form {
                    
                    // About & Policy
                    Section(header: Text("About")) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                        NavigationLink("Privacy Policy", destination: Text("Privacy Policy Details"))
                        NavigationLink("Terms of Service", destination: Text("Terms of Service Details"))
                    }
                }
                
                
                
            }
            

            
            
            
        }
    }
}

#Preview {
    SettingsView()
}



