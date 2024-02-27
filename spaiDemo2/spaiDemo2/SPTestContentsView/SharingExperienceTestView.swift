//
//  SharingExperienceTestView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/10/24.
//

import SwiftUI
import SiriWaveView

struct SharingExperienceTestView: View {
    @StateObject private var viewModel = TestViewModel()
    @State private var showScoreSheet = false
    @State private var questionText: String?

    var body: some View {
        VStack {
            SiriWaveView()
                .power(power: viewModel.speakingPower)
                .frame(height: 200)
            
            if let question = questionText {
                Text(question)
            }

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
                } else {
                    Text("Start Recording")
                }
            }
            .buttonStyle(RecShadowButtonStyle())
        }
        .fullScreenCover(isPresented: $showScoreSheet) {
            ScoreViewMode(gradedResponse: viewModel.gradedResponse ?? "No response graded yet.", scoringFeedback: viewModel.scoringFeedback)
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.requestMicrophoneAccess()
            viewModel.requestSpeechRecognitionPermission()
            fetchSharingExperienceQuestion()
        }
    }

    private func fetchSharingExperienceQuestion() {
        QuestionService.fetchSharingExperienceQuestion { question in
            self.questionText = question
            viewModel.speakQuestion(question: question ?? "No question fetched.")
        }
    }
}


#Preview {
    SharingExperienceTestView()
}
