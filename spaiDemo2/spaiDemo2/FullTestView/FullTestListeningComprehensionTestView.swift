//
//  FullTestListeningComprehensionTestView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 2/23/24.
//

import SwiftUI
import SiriWaveView

struct FullTestListeningComprehensionTestView: View {
    @EnvironmentObject var viewModel: TestViewModel
    @State private var questionText: String?
    @State private var isNextQuestionButtonEnabled = false
    @State private var showExpressingOpinionTest = false

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
                    isNextQuestionButtonEnabled = true
                }
                .buttonStyle(RecShadowButtonStyle())
            } else {
                Button("Start Recording") {
                    viewModel.startRecording()
                }
                .buttonStyle(RecShadowButtonStyle())
            }
            
            Button("Next Question") {
                showExpressingOpinionTest = true
            }
            .disabled(!isNextQuestionButtonEnabled)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(isNextQuestionButtonEnabled ? Color.black : Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .animation(.easeInOut, value: isNextQuestionButtonEnabled)
        }
        .fullScreenCover(isPresented: $showExpressingOpinionTest) {
            FullTestExpressingOpinionTestView()
        }
        .onAppear {
            viewModel.requestMicrophoneAccess()
            viewModel.requestSpeechRecognitionPermission()
            fetchListeningComprehensionQuestion()
        }
    }

    private func fetchListeningComprehensionQuestion() {
        QuestionService.fetchListeningComprehensionQuestion { question in
            self.questionText = question
            viewModel.speakQuestion(question: question ?? "No question fetched.")
        }
    }
}


#Preview {
    FullTestListeningComprehensionTestView()
}
