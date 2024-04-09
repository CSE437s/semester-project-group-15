//
//  FullTestStartCountView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 2/23/24.
//

import SwiftUI

struct FullTestStartCountView: View {
    @EnvironmentObject var viewModel: TestViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var countdown = 5
    @State private var showShortDescriptionTest = false

    var body: some View {
        VStack(spacing: 20) {
            if countdown > 0 {
                Text("Starting in \(countdown)...")
                    .font(.largeTitle)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            if self.countdown > 0 {
                                self.countdown -= 1
                            } else {
                                timer.invalidate()
                                self.showShortDescriptionTest = true
                            }
                        }
                    }
            }

            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
        .fullScreenCover(isPresented: $showShortDescriptionTest) {
            FullTestShortDescriptionTestView()
                .environmentObject(viewModel) // viewModel is received from HomeView
        }
    }
}


#Preview {
    FullTestStartCountView()
}
