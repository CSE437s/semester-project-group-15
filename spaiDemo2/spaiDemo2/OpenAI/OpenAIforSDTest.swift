//
//  OpenAIforSDTest.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

import Foundation
import AVFoundation
import OpenAI

class OpenAIforSDTest {
    private var openAI: OpenAI
    private var speechSynthesizer = AVSpeechSynthesizer()

    init(apiToken: String) {
        self.openAI = OpenAI(apiToken: apiToken)
    }

    func fetchQuestion(completion: @escaping (String?) -> Void) {
        // Generate a test question using OpenAI
        let prompt = "Generate a short description question suitable for a speaking test."
        let query = CompletionsQuery(model: .gpt3_5Turbo, prompt: prompt, maxTokens: 100)

        openAI.completions(query: query) { result in
            switch result {
            case .success(let completionResult):
                let question = completionResult.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines)
                DispatchQueue.main.async {
                    completion(question)
                }
            case .failure(let error):
                print("Failed to fetch question: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func speak(text: String, completion: @escaping () -> Void) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        speechSynthesizer.speak(utterance)
        completion()
    }

    // Add more functions as needed for handling user responses, follow-up questions, etc.
}

