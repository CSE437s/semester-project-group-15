//
//  ShortDescriptionTestView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

//SiriWaveView()
//    .power(power: audioPower)
//    .frame(height: 200)

import SwiftUI
import SiriWaveView

struct ShortDescriptionTestView: View {
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
                    showScoreSheet = true  // Trigger sheet presentation
                } else {
                    viewModel.startRecording()
                }
            }) {
                // Conditionally render the button's label
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
            fetchShortDescriptionQuestion()
//            viewModel.fetchQuestion()
        }

    }
    
    
    private func fetchShortDescriptionQuestion() {
        QuestionService.fetchShortDescriptionQuestion { question in
            self.questionText = question
            viewModel.speakQuestion(question: question ?? "No question fetched.")
        }
    }
    
    
}








#Preview {
    ShortDescriptionTestView()
}
