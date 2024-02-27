//
//  QuestionService.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

import Foundation
import OpenAI

struct QuestionService {
    static let openAI = OpenAI(apiToken: "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")
    
    static func fetchShortDescriptionQuestion(completion: @escaping (String?) -> Void) {
        let query = ChatQuery(
            model: .gpt4_1106_preview,
            messages: [.init(role: .user, content: "Create a speaking test question in two sentences, suitable for CEFR B2 level, about a randomly chosen topic such as daily activities, hobbies, personal interests, memorable experiences, or experience using technology. The language used should be clear and accessible for B2 learners, avoiding complex or highly specialized vocabulary. Please ensure the question is direct and does not include any introductory phrases.")],
            maxTokens: 100
        )
        
        openAI.chats(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    let response = chatResult.choices.first?.message.content
                    completion(response)
                case .failure(let error):
                    print("Error fetching short description question: \(error)")
                    completion(nil)
                }
            }
        }
    }
    
    static func fetchSharingExperienceQuestion(completion: @escaping (String?) -> Void) {
        let query = ChatQuery(
            model: .gpt4_1106_preview,
            messages: [.init(role: .user, content: "Create a speaking test question in two sentences prompting the user to share a personal experience. The question should be suitable for CEFR B2 level and encourage detailed responses on topics such as personal achievements, travel experiences, memorable events, personal growth, or assisting/helping someone. It should be sutible to test user's ability to narrate events, explain process, or express personal reflections. The language used should be clear and accessible for B2 learners, avoiding complex or highly specialized vocabulary. Please ensure the question is direct and does not include any introductory phrases.")],
            maxTokens: 100
        )
        
        openAI.chats(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    let response = chatResult.choices.first?.message.content
                    completion(response)
                case .failure(let error):
                    print("Error fetching sharing experience question: \(error)")
                    completion(nil)
                }
            }
        }
    }
    
    

    /*
     Generate a comprehensive four-sentence paragraph suitable for a CEFR B2 level listening comprehension test. The content should be based on a spoken narrative, such as a story, book, movie, article, or every day topics (work, education, nature, technology, etc). And it should be able to test the user's ability to understand and summarize spoken English. The question should directly prompt users to listen to the content. Please ensure the content is direct and does not include any introductory phrases.
     */
    static func fetchListeningComprehensionQuestion(completion: @escaping (String?) -> Void) {
        let query = ChatQuery(
            model: .gpt4_1106_preview,
            messages: [.init(role: .user, content: "Generate a comprehensive four-sentence paragraph suitable for a CEFR B2 level listening comprehension test. The content should be based on a spoken narrative, such as a story, book, movie, article, or every day topics (work, education, nature, technology, etc). And it should be able to test the user's ability to understand and summarize spoken English. The question should directly prompt users to listen to the content. Please ensure the content is direct and does not include any introductory phrases.")],
            maxTokens: 100
        )
        
        openAI.chats(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    let response = chatResult.choices.first?.message.content
                    completion(response)
                case .failure(let error):
                    print("Error fetching listening comprehension question: \(error)")
                    completion(nil)
                }
            }
        }
    }
    
    /*
     Create a speaking test question in two sentences, suitable for CEFR B2 level, that prompts CEFR B2 level learners to express their opinions on a given topic, such as technological advancements, cultural practices, personal beliefs, societal trends, work, education, nature, sustaniablity, etc. The language used should be clear and accessible for B2 learners, avoiding complex or highly specialized vocabulary. Please ensure the question is direct and does not include any introductory phrases.
     */
    
    static func fetchExpressingOpinionQuestion(completion: @escaping (String?) -> Void) {
        let query = ChatQuery(
            model: .gpt4_1106_preview,
            messages: [.init(role: .user, content: "Create a speaking test question in two sentences, suitable for CEFR B2 level, that prompts CEFR B2 level learners to express their opinions on a given topic, such as technological advancements, cultural practices, personal beliefs, societal trends, work, education, nature, sustaniablity, etc. The language used should be clear and accessible for B2 learners, avoiding complex or highly specialized vocabulary. Please ensure the question is direct and does not include any introductory phrases.")],
            maxTokens: 100
        )
        
        openAI.chats(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    let response = chatResult.choices.first?.message.content
                    completion(response)
                case .failure(let error):
                    print("Error fetching expressing opinion question: \(error)")
                    completion(nil)
                }
            }
        }
    }
    
}

