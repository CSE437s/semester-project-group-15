//
//  FullTestExpressingOpinionTestView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 2/23/24.
//

import SwiftUI
import SiriWaveView

struct FullTestExpressingOpinionTestView: View {
    @EnvironmentObject var viewModel: TestViewModel
    @State private var questionText: String?
    @State private var isSubmitAnswersButtonEnabled = false
    @State private var showFullTestScoreView = false

    var body: some View {
        VStack {
            SiriWaveView()
                .power(power: viewModel.speakingPower)
                .frame(height: 200)
            
            if let question = questionText {
                Text(question)
            }

            if viewModel.isRecording {
                Button("Send") {
                    viewModel.stopRecordingForFullTest()
                    isSubmitAnswersButtonEnabled = true
                }
                .buttonStyle(RecShadowButtonStyle())
            } else {
                Button("Start Recording") {
                    viewModel.startRecording()
                }
                .buttonStyle(RecShadowButtonStyle())
            }
            
            Button("Submit Answers") {
                showFullTestScoreView = true
            }
            .disabled(!isSubmitAnswersButtonEnabled)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(isSubmitAnswersButtonEnabled ? Color.black : Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .animation(.easeInOut, value: isSubmitAnswersButtonEnabled)
        }
        .fullScreenCover(isPresented: $showFullTestScoreView) {
            FullTestScoreView()
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.requestMicrophoneAccess()
            viewModel.requestSpeechRecognitionPermission()
            fetchExpressingOpinionQuestion()
        }
    }

    private func fetchExpressingOpinionQuestion() {
        QuestionService.fetchExpressingOpinionQuestion { question in
            self.questionText = question
            viewModel.speakQuestion(question: question ?? "No question fetched.")
        }
    }
}


#Preview {
    FullTestExpressingOpinionTestView()
}
