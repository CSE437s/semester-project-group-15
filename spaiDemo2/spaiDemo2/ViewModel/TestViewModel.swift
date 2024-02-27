//
//  TestViewModel.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/10/24.
//
// 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
// api key here
import Foundation
import AVFoundation
import Speech
import OpenAI
import CoreData

class TestViewModel: NSObject, ObservableObject {
    
    @Published var isSpeaking = false
    @Published var speakingPower: Double = 0.0
    @Published var isRecording = false
//    @Published var audioPower: Double = 0.0
    
    @Published var userAnswer: String?
    @Published var questionText: String?
    @Published var grade: Int?
    @Published var gradedResponse: String?
    @Published var scoringFeedback: String?
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var audioRecorder: AVAudioRecorder?
    
    private var speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let openAI = OpenAI(apiToken: "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")
    
    func fetchQuestion() {
        // Initialize a chat session with a system message prompting a question generation

        let query = ChatQuery(
            model: .gpt4_1106_preview,
            messages: [.init(role: .user, content: "Create a speaking test question in two sentences, suitable for CEFR B2 level, about a randomly chosen topic such as daily activities, personal interests, memorable experiences, or experience using technology. The language used should be clear and accessible for B2 learners, avoiding complex or highly specialized vocabulary. Please ensure the question is direct and does not include any introductory phrases.")],
            maxTokens: 100
        )
        
        openAI.chats(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    // Assuming the model's response with the generated question is the first in the choices array
                    if let response = chatResult.choices.first?.message.content {
                        self?.questionText = response
                        self?.speakQuestion(question: response)
                    }
                case .failure(let error):
                    print("Error fetching question: \(error)")
                }
            }
        }
    }
    


//    func speakQuestion(question: String) {
//        let utterance = AVSpeechUtterance(string: question)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        speechSynthesizer.speak(utterance)
//    }
    func speakQuestion(question: String) {
        let utterance = AVSpeechUtterance(string: question)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        // Notify the view that speaking will start
        DispatchQueue.main.async {
            self.isSpeaking = true
            self.speakingPower = 0.3
        }

        speechSynthesizer.speak(utterance)

        // Monitor when speaking is finished
        speechSynthesizer.delegate = self
    }


    
    func startRecording() {
        // Additional setup for audioEngine and recognitionRequest
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode // Directly using inputNode without guard let
        recognitionRequest?.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false

            if let result = result {
                self.userAnswer = result.bestTranscription.formattedString
                self.gradedResponse = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.isRecording = false
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        isRecording = true
    }



    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
        
        if let responseText = gradedResponse {
            sendResponseForScoring(response: responseText)
        }
        
    }
    
//    func transcribeAudio(url: URL) {
//        let recognizer = SFSpeechRecognizer()
//        let request = SFSpeechURLRecognitionRequest(url: url)
//        recognizer?.recognitionTask(with: request) { [weak self] (result, error) in
//            guard let result = result, result.isFinal else { return }
//            
//            let responseText = result.bestTranscription.formattedString
//            self?.sendResponseForScoring(response: responseText)
//        }
//    }
    
    
    // ***************************************************************
    // This method orchestrates the process of scoring and then grading the response
//    func evaluateAndGradeResponse(response: String) {
//        sendResponseForScoring(response: response) { [weak self] feedback in
//            guard let feedback = feedback else { return }
//            self?.sendResponseForGrading(response: response, feedback: feedback)
//        }
//    }
    
    func sendResponseForScoring(response: String) {
        let newPrompt = "Grade the English response below using only numbers, no explanations. While you should still grade it correctly, do not provide any explanations about the grade at all. Deduct 1 point for each grammar mistake from a total of 40 points. Assess relevance out of 30 points, deducting for answers not directly addressing the question. Evaluate vocabulary out of 30 points, with deductions for inappropriate or incorrect word usage. Present the grades in this exact format (on a separate line): Grammar: [grade]/40 Relevance: [grade]/30 Vocabulary: [grade]/30 Response to evaluate: \(response)"
        let query = ChatQuery(
            model: .gpt4_1106_preview,
            messages: [.init(role: .user, content: newPrompt)],
            maxTokens: 150
        )

        openAI.chats(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    if let feedback = chatResult.choices.last?.message.content {
                        print("Scoring Feedback: \(feedback)")
                        self?.scoringFeedback = feedback
                    }
                case .failure(let error):
                    print("Error scoring response: \(error)")
                }
            }
        }
    }
    
    
    
    func sendResponseForGradingWithFeedback() {
        guard let responseText = gradedResponse, let feedback = scoringFeedback else {
            print("Required data for detailed grading is not available.")
            return
        }
        sendResponseForGrading(response: responseText, feedback: feedback)
    }
    private func sendResponseForGrading(response: String, feedback: String) {
        guard let feedback = scoringFeedback else {
            print("No scoring feedback available.")
            return
        }
        
        let combinedPrompt = "Given the user's response and the following scoring feedback, explain the reasoning behind each score. Provide a concise explanation for the deductions in the grades below, focusing solely on the specific errors or issues in the response that led to points being deducted. Do not include any general comments or feedback. Directly highlight and explain only the parts of the response that resulted in deductions for grammar, relevance, and vocabulary. Grades received: \(feedback) User's Response: \(response)"
        
        let query = ChatQuery(
            model: .gpt4_1106_preview,  // Or any other suitable model
            messages: [
                .init(role: .user, content: combinedPrompt)],
            maxTokens: 200  // Adjust based on your needs
        )

        openAI.chats(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatResult):
                    // Assume the grading or feedback is the last message from the AI
                    if let grade = chatResult.choices.last?.message.content {
                        print("Grade/Feedback: \(grade)")
                        self?.gradedResponse = grade
                    }
                case .failure(let error):
                    print("Error grading response: \(error)")
                }
            }
        }
        
    }

    // ***************************************************************
    
    
    func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone access granted")
                // Proceed with setting up the recording session
            } else {
                print("Microphone access denied")
                // Handle the error (perhaps alert the user that the app needs microphone access)
            }
        }
    }
    
    func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speech recognition authorized")
            default:
                print("Speech recognition not authorized")
            }
        }
    }
    
    
    
    // Additional methods as needed...
}


extension TestViewModel {
    func saveQA(question: String, answer: String, grade: Int) {
        let context = PersistenceController.shared.container.viewContext
        let newQA = QuestionAnswer(context: context)
        newQA.question = question
        newQA.answer = answer
        newQA.grade = Int16(grade)
        
        do {
            try context.save()
            print("QA saved successfully")
        } catch {
            print("Failed to save QA: \(error.localizedDescription)")
        }
    }
    
    func fetchAllQA() -> [QuestionAnswer] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<QuestionAnswer> = QuestionAnswer.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch QA: \(error.localizedDescription)")
            return []
        }
    }
}

extension TestViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.speakingPower = 0.0
        }
    }
}


// Create a speaking test question in two sentences, suitable for CEFR B2 level, about a randomly chosen topic such as daily activities, personal interests, memorable experiences, or experience using technology. The language used should be clear and accessible for B2 learners, avoiding complex or highly specialized vocabulary. Please ensure the question is direct and does not include any introductory phrases.

//Generate a specific question for a speaking test in two sentences, focusing on a randomly chosen topic such as technology, daily activities, hobbies, travel, or any other interesting subject. The question should invite participants to share detailed insights or experiences related to the chosen topic. Please ensure the question is direct and does not include any introductory phrases.

//    private func convertTextToSpeech(text: String) {
//        let query = AudioSpeechQuery(
//            model: .tts_1,  // Assuming tts1 supports the desired voice and language
//            input: text,
//            voice: .nova,  // Choose an appropriate voice
//            responseFormat: .mp3,  // Choose your desired audio format
//            speed: 1.0  // Set the speed as needed
//        )
//
//        openAI.audioCreateSpeech(query: query) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let audioResult):
//                    if let audioData = audioResult.audioData {
//                        // Play the audio data using an audio player
//                        self?.playAudio(data: audioData)
//                    }
//                case .failure(let error):
//                    print("Error generating speech: \(error)")
//                }
//            }
//        }
//    }
//
//    private func playAudio(data: Data) {
//        do {
//            let audioPlayer = try AVAudioPlayer(data: data)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        } catch {
//            print("Failed to play audio: \(error)")
//        }
//    }


//    private func gradeResponse(response: String) {
//        let prompt = "Grade the response: \(response)"
//        let query = CompletionsQuery(model: .gpt3_5Turbo, prompt: prompt, maxTokens: 50)
//
//        openAI.completions(query: query) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let completionResult): break
//                    // Parse completionResult to extract the grade
//                    // Update self?.grade accordingly
//                case .failure(let error):
//                    print("Error grading response: \(error)")
//                }
//            }
//        }
//    }


// stop recording
//        // If there's transcribed text available, first get the scoring feedback
//        if let responseText = gradedResponse {
//            sendResponseForScoring(response: responseText) { [weak self] feedback in
//                // Once the feedback is available, proceed to grade the response with it
//                if let feedback = feedback {
//                    self?.sendResponseForGrading(response: responseText, feedback: feedback)
//                }
//            }
//        }



//func transcribeAudio(url: URL) {
//      // Existing setup code...
//
//      recognizer?.recognitionTask(with: request) { [weak self] (result, error) in
//          guard let result = result, result.isFinal else { return }
//
//          // Store the transcribed text in userAnswer instead of gradedResponse
//          self?.userAnswer = result.bestTranscription.formattedString
//
//          // Optionally, you might want to send the userAnswer for scoring here
//          if let userAnswer = self?.userAnswer {
//              self?.sendResponseForScoring(response: userAnswer)
//          }
//      }
//  }
