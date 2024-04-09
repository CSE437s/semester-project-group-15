//
//  SharingExperienceTestView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/10/24.
//

import SwiftUI
import SiriWaveView
import AVKit

struct SharingExperienceTestView: View {
    @StateObject private var viewModel = TestViewModel()
    @State private var showScoreSheet = false
    // @State private var questionText: String?
    var questionText: String
    var clipUrl: String?
    
    var body: some View {
        VStack {
            
            Text("Sharing Experience\nTest")
                .font(
                Font.custom("Roboto", size: 32)
                .weight(.black)
                )
                .foregroundColor(Color(red: 0, green: 0.51, blue: 0.65))
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            VStack {
//                ZStack {
//                    Circle()
//                        .fill(Color(red: 0.05, green: 0.8, blue: 0.76))
//                        .frame(width: 250, height: 250)
//                    SiriWaveView()
//                        .power(power: viewModel.speakingPower)
//                        .frame(width: 400, height: 200)
//                }
                // Use VideoPlayer if clipUrl is available
                if let clipUrlString = clipUrl, let url = URL(string: clipUrlString) {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(width: 400, height: 225)
                        .cornerRadius(12)
                        .overlay(Circle().stroke(Color(red: 0.05, green: 0.8, blue: 0.76), lineWidth: 4))
                } else {
                    // Fallback content if no video URL
                    Text("Loading video...")
                        .foregroundColor(.white)
                }
                
                Text("Listen Carefully")
                    .font(
                    Font.custom("Roboto", size: 20)
                    .weight(.black)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0, green: 0.51, blue: 0.65))
                    .padding(.top, 20)
            }
            .padding(.top, 50)
            .padding(.bottom, 50)
            
//            if let question = questionText {
//                Text(question)
//            }

            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                    showScoreSheet = true
                } else {
                    viewModel.startRecording()
                }
            }) {
                if viewModel.isRecording {
                    Text("Send")
                        .font(
                        Font.custom("Roboto", size: 20)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                } else {
                    Text("Start Recording")
                        .font(
                        Font.custom("Roboto", size: 20)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(RecShadowButtonStyle())
        }
        .fullScreenCover(isPresented: $showScoreSheet) {
            ScoreViewMode(gradedResponse: viewModel.gradedResponse ?? "No response graded yet.", scoringFeedback: viewModel.scoringFeedback)
                .environmentObject(viewModel)
        }
        .onAppear {
            // viewModel.speakQuestion(question: questionText)
            viewModel.testName = "Sharing Experience Test"
            viewModel.oneTypeQuestionText = questionText 
            viewModel.requestMicrophoneAccess()
            viewModel.requestSpeechRecognitionPermission()
            //fetchSharingExperienceQuestion()
        }
    }

//    private func fetchSharingExperienceQuestion() {
//        QuestionService.fetchSharingExperienceQuestion { question in
//            self.questionText = question
//            self.viewModel.oneTypeQuestionText = question ?? "No question available"
//            viewModel.speakQuestion(question: question ?? "No question fetched.")
//        }
//    }
}


#Preview {
    SharingExperienceTestView(questionText: "Describe a hobby or personal interest you are passionate about. What makes it special to you, and how do you think it benefits your life?")
}
