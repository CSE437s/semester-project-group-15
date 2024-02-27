//
//  ScoreViewMode.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/17/24.
//

import SwiftUI

struct ScoreViewMode: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var testViewModel: TestViewModel
    
    let gradedResponse: String
    let scoringFeedback: String?
    
    @State private var showDetails = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Evaluation Results")
                .font(.title)
                .padding(.bottom)

            if let feedback = scoringFeedback {
                VStack(spacing: 10) {
                    HStack {
                        Text("Scoring Feedback")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                        
                        
                        Button("See Details") {
                            testViewModel.sendResponseForGradingWithFeedback()
                            showDetails = true
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .sheet(isPresented: $showDetails) {
                            GradingDetailsView(
                                feedback: testViewModel.scoringFeedback ?? "No feedback",
                                detailedGrading: testViewModel.gradedResponse ?? "No detailed grading"
                            )
                                .environmentObject(testViewModel)
                        }
                    }
                    
                    ScrollView {
                        Text(feedback)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                    .frame(maxHeight: 150)
                    

                }
            }


            Button("Return to Dashboard") {
                navigationStateManager.resetToHome()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
    }
}


struct ScoreViewMode_Previews: PreviewProvider {
    static var previews: some View {
        // Provide sample data for the preview
        ScoreViewMode(gradedResponse: "This is a sample graded response to show how the content will look like. It should provide insightful feedback based on the user's answer.", scoringFeedback: "Scoring feedback is intended to provide additional insights or suggestions on how the response could be improved or what aspects were particularly strong.")
        .environmentObject(NavigationStateManager()) // Ensure the environment object is provided if it's required for navigation
    }
}

//struct ScoreViewMode: View {
//    let grammarScore: Int
//    let relevanceScore: Int
//    let wordUseScore: Int
//    var totalScore: Int {
//        grammarScore + relevanceScore + wordUseScore
//    }
//
//    var body: some View {
//        VStack {
//            Text("Your Scores")
//                .font(.title)
//            HStack {
//                ScoreButton(label: "Grammar: \(grammarScore) points")
//                ScoreButton(label: "Relevance: \(relevanceScore) points")
//                ScoreButton(label: "Word Use: \(wordUseScore) points")
//            }
//            Text("Total Score: \(totalScore) points")
//                .font(.headline)
//        }
//    }
//}
//
//struct ScoreButton: View {
//    var label: String
//
//    var body: some View {
//        Button(action: {
//            // Action to show deductions
//        }) {
//            Text(label)
//                .padding()
//                .background(Color.green)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
//        }
//    }
//}



//#Preview {
//    ScoreViewMode()
//}
