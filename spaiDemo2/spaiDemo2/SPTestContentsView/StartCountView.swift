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
    @EnvironmentObject var testViewModel: TestViewModel // added for pre-fetch
    
    var testType: TestType
    
    @State private var isCountingDown = false
    @State private var countdown = 5
    
    @State private var showTestView = false
    @State private var fetchedQuestion: String? // added for pre-fetch
    @State private var isFetchingData = false
    @State private var showContinueButton = false

    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.44, blue: 0.4)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if isFetchingData {
                    ProgressView("Preparing Speaking Test...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding()
                } else if showContinueButton {
                    Button("Continue") {
                        showTestView = true
                    }
                    .font(.title)
                    .padding()
                    .background(Color(red: 0.98, green: 0.79, blue: 0.77))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                } else {
                    Button("Start Test") {
                        isFetchingData = true
                        fetchQuestion(for: testType) {
//                            guard let fetchedQuestion = self.fetchedQuestion else {
//                                self.isFetchingData = false
//                                return
//                            }
//                            // Create and fetch clip with the fetched question
//                            DIDService.createClip(withText: fetchedQuestion) { clipId in
//                                guard let clipId = clipId else {
//                                    self.isFetchingData = false
//                                    return
//                                }
//                                DIDService.fetchClip(withId: clipId) { clipUrl in
//                                    DispatchQueue.main.async {
//                                        self.testViewModel.clipUrl = clipUrl
//                                        self.isFetchingData = false
//                                        self.showContinueButton = true
//                                    }
//                                }
//                            }
                        }
                    }
                    .font(.title)
                    .padding()
                    .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.77))
                }
                
                Button("Back") {
    //                presentationMode.wrappedValue.dismiss()
                    navigationStateManager.selectedTestType = nil
                }
                .font(
                Font.custom("Roboto", size: 20)
                .weight(.black)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.77))
                .padding()
                
            }
        }
        .fullScreenCover(isPresented: $showTestView) {
            destinationView(for: testType, questionText: fetchedQuestion ?? "No question available")
        }
        
        
    }
    
    
//    private func startCountdown() {
//        isCountingDown = true
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            if countdown > 0 {
//                countdown -= 1
//            } else {
//                timer.invalidate()
//                showTestView = true
//            }
//        }
//    }
    
    
    // added for pre-fetch
    private func fetchQuestion(for testType: TestType, completion: @escaping () -> Void) {
        switch testType {
        case .shortDescription:
            QuestionService.fetchShortDescriptionQuestion { question in
                self.fetchedQuestion = question
                self.testViewModel.oneTypeQuestionText = question ?? "No question available2"
                completion()
                // clip
                guard let fetchedQuestion = self.fetchedQuestion else {
                    self.isFetchingData = false
                    return
                }
                // Create and fetch clip with the fetched question
                DIDService.createClip(withText: fetchedQuestion) { clipId in
                    guard let clipId = clipId else {
                        self.isFetchingData = false
                        return
                    }
                    DIDService.fetchClip(withId: clipId) { clipUrl in
                        DispatchQueue.main.async {
                            self.testViewModel.clipUrl = clipUrl
                            self.isFetchingData = false
                            self.showContinueButton = true
                        }
                    }
                }
            }
        case .sharingExperience:
            QuestionService.fetchSharingExperienceQuestion { question in
                self.fetchedQuestion = question
                self.testViewModel.oneTypeQuestionText = question ?? "No question available"
                completion()
                // clip
                guard let fetchedQuestion = self.fetchedQuestion else {
                    self.isFetchingData = false
                    return
                }
                // Create and fetch clip with the fetched question
                DIDService.createClip(withText: fetchedQuestion) { clipId in
                    guard let clipId = clipId else {
                        self.isFetchingData = false
                        return
                    }
                    DIDService.fetchClip(withId: clipId) { clipUrl in
                        DispatchQueue.main.async {
                            self.testViewModel.clipUrl = clipUrl
                            self.isFetchingData = false
                            self.showContinueButton = true
                        }
                    }
                }
                
            }
        case .listeningComprehension:
            QuestionService.fetchListeningComprehensionQuestion { question in
                self.fetchedQuestion = question
                self.testViewModel.oneTypeQuestionText = question ?? "No question available"
                completion()
                self.isFetchingData = false
                self.showContinueButton = true
            }
        case .expressingOpinion:
            QuestionService.fetchExpressingOpinionQuestion { question in
                self.fetchedQuestion = question
                self.testViewModel.oneTypeQuestionText = question ?? "No question available"
                completion()
                self.isFetchingData = false
                self.showContinueButton = true
            }
        }
    }

    @ViewBuilder
    private func destinationView(for testType: TestType, questionText: String) -> some View {
        switch testType {
        case .shortDescription:
            ShortDescriptionTestView(questionText: questionText, clipUrl: testViewModel.clipUrl).environmentObject(testViewModel)
        case .sharingExperience:
            SharingExperienceTestView(questionText: questionText, clipUrl: testViewModel.clipUrl).environmentObject(testViewModel)
        case .listeningComprehension:
            ListeningComprehensionTestView(questionText: questionText).environmentObject(testViewModel)
        case .expressingOpinion:
            ExpressingOpinionTestView(questionText: questionText).environmentObject(testViewModel)
        }
    }
}





#Preview {
    StartCountView(testType: .shortDescription)
}
