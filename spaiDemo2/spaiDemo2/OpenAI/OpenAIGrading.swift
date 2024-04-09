//
//  OpenAIGrading.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

import Foundation
import OpenAI

class OpenAIGrading {
    private var openAI: OpenAI

    init(apiToken: String) {
        self.openAI = OpenAI(apiToken: apiToken)
    }

    func gradeResponse(response: String, question: String, completion: @escaping (Int) -> Void) {
        // Simplified grading logic using OpenAI
        // You may need a more sophisticated model or custom logic for accurate grading
        let prompt = "Grade the following response based on grammar, relevance to the question, and appropriateness of word use. Question: \(question) Response: \(response)"
        let query = CompletionsQuery(model: .gpt3_5Turbo, prompt: prompt, maxTokens: 10)

        openAI.completions(query: query) { result in
            switch result {
            case .success(let completionResult):
                let gradeInfo = completionResult.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines)
                // Parse the gradeInfo to extract the score
                // This is a placeholder; you'll need to parse the response according to your grading logic
                let score = Int(gradeInfo ?? "") ?? 0
                DispatchQueue.main.async {
                    completion(score)
                }
            case .failure(let error):
                print("Failed to grade response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(0)  // Consider handling errors more gracefully
                }
            }
        }
    }

    // Add more functions as needed for detailed grading criteria
}

