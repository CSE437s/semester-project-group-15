//
//  StartCountView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/7/24.
//

import SwiftUI

//enum TestType {
//    case shortDescription
//    case sharingExperience
//    case listeningComprehension
//    case expressingOpinion
//}

enum TestType: Identifiable {
    case shortDescription
    case sharingExperience
    case listeningComprehension
    case expressingOpinion

    var id: Self { self }
}

struct StartCountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var testType: TestType
    
    @State private var isCountingDown = false
    @State private var countdown = 5
    @State private var showTestView = false

    var body: some View {
        VStack {
            if isCountingDown {
                Text("\(countdown)")
                    .font(.largeTitle)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            if countdown > 0 {
                                countdown -= 1
                            } else {
                                timer.invalidate()
                                showTestView = true
                            }
                        }
                    }
            } else {
                Button("Start Test") {
                    isCountingDown = true
                }
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            
            Button("Back") {
//                presentationMode.wrappedValue.dismiss()
                navigationStateManager.selectedTestType = nil
            }
            .padding()
            .accentColor(.blue)
            
        }
        .fullScreenCover(isPresented: $showTestView) {
            destinationView(for: testType)
        }
    }

    @ViewBuilder
    private func destinationView(for testType: TestType) -> some View {
        switch testType {
        case .shortDescription:
            ShortDescriptionTestView()
        case .sharingExperience:
            SharingExperienceTestView()
        case .listeningComprehension:
            ListeningComprehensionTestView()
        case .expressingOpinion:
            ExpressingOpinionTestView()
        }
    }
}





//#Preview {
//    StartCountView()
//}
