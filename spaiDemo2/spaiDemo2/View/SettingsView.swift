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

                Form {
                    Section(header: Text("Version")) { // Version
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                    }
                    Section(header: Text("Support & About")) { // Support & About
                        NavigationLink("My Subscription", destination: Text("My Subscription Details"))
                        NavigationLink("Terms and Policies", destination: Text("Terms and Policies"))
                    }
                    Section(header: Text("Actions")) { // Actions
                        NavigationLink("Report a problem", destination: Text("Report a problem Details"))
                        // NavigationLink("Log Out", destination: Text("Log Out"))
                    }
                }
                
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
                .padding()
                
                
            } // VStack
        } // NavigationView
        
        
    }
}

#Preview {
    SettingsView()
}



