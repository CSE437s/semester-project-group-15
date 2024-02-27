//
//  TabBarView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var navigationStateManager = NavigationStateManager()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(navigationStateManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            Text("History View Placeholder")
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }

            Text("Profile View Placeholder")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

