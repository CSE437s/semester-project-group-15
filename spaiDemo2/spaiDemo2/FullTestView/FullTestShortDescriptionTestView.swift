//
//  FullTestShortDescriptionTestView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 2/23/24.
//

import SwiftUI
import SiriWaveView

struct FullTestShortDescriptionTestView: View {
//    @StateObject private var viewModel = TestViewModel()
    @EnvironmentObject var viewModel: TestViewModel
    @State private var questionText: String?
    @State private var isNextQuestionButtonEnabled = false
    @State private var showSharingExperienceTest = false

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
                showSharingExperienceTest = true
            }
            .disabled(!isNextQuestionButtonEnabled)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(isNextQuestionButtonEnabled ? Color.black : Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .animation(.easeInOut, value: isNextQuestionButtonEnabled)
            

        }
        .fullScreenCover(isPresented: $showSharingExperienceTest) {
            FullTestSharingExperienceTestView()
        }
        .onAppear {
            viewModel.requestMicrophoneAccess()
            viewModel.requestSpeechRecognitionPermission()
            fetchShortDescriptionQuestion()
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
    FullTestShortDescriptionTestView()
}
