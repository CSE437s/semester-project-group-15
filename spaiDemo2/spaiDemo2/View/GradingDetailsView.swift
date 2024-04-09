//
//  GradingDetailsView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/11/24.
//

import SwiftUI
import Firebase

struct GradingDetailsView: View {
    @EnvironmentObject var testViewModel: TestViewModel
    
    @State private var showingSaveSuccessAlert = false

    let feedback: String
    let detailedGrading: String
    
    // Firestore database reference
    let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 20) {
            Text("Detailed Grading")
                .font(.title)
                .padding()
            
            ScrollView {
                Text("Feedback:\n\(feedback)")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("User's Answer:\n\(testViewModel.userAnswer ?? "No user answer")")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("Detailed Grading:\n\(detailedGrading)")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            Button("Save to History") {
                saveToHistory()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .alert("Saved Successfully", isPresented: $showingSaveSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveToHistory() {
        // Check if the user is logged in before attempting to save to Firestore
        if let userID = Auth.auth().currentUser?.uid {
            print("User ID: \(userID)")
            
            let historyData: [String: Any] = [
                "date": Timestamp(date: Date()),
                "testName": testViewModel.testName,
                "question": testViewModel.oneTypeQuestionText ,
                "userAnswer": testViewModel.userAnswer ?? "No answer recorded",
                "score": testViewModel.scoringFeedback ?? "No score recorded",
                "detailGrading": detailedGrading
            ]
            
            // Proceed with Firestore operation
            db.collection("users").document(userID).collection("testHistory").addDocument(data: historyData) { error in
                if let error = error {
                    print("Error saving test history: \(error.localizedDescription)")
                } else {
                    print("Test history successfully saved")
                    self.showingSaveSuccessAlert = true // Show success alert
                }
            }
        } else {
            print("User not logged in")
        }
    }

    
}

//#Preview {
//    GradingDetailsView(feedback: "Example feedback text.", detailedGrading: "Example detailed grading text. Here you might find a detailed breakdown of the grading criteria and how the user's answer met those criteria.")
//}

