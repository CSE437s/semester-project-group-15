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
        ZStack {
            Color(red: 0.05, green: 0.8, blue: 0.76)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Test Results")
                    .font(
                    Font.custom("Roboto", size: 30)
                    .weight(.black)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                if let feedback = scoringFeedback {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 331, height: 358)
                            .background(.white)
                            .cornerRadius(55)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Scoring Feedback")
                                    .font(
                                    Font.custom("Roboto", size: 23)
                                    .weight(.black)
                                    )
                                    .foregroundColor(Color(red: 0, green: 0.51, blue: 0.65))
                                    .padding()
                            }
                            // will change this to horizontal bar graph later
                            ScrollView {
                                Text(feedback)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                            .frame(maxWidth: 300, maxHeight: 150)
                            
                            Button("See Details") {
                                testViewModel.sendResponseForGradingWithFeedback()
                                showDetails = true
                            }
                            .font(
                            Font.custom("Roboto", size: 20)
                            .weight(.bold)
                            )
                            .padding()
                            .foregroundColor(Color(red: 0, green: 0.51, blue: 0.65))
                            .sheet(isPresented: $showDetails) {
                                GradingDetailsView(
                                    feedback: testViewModel.scoringFeedback ?? "No feedback",
                                    detailedGrading: testViewModel.gradedResponse ?? "No detailed grading"
                                )
                                    .environmentObject(testViewModel)
                            }
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                } // end of if


                Button("Return to Dashboard") {
                    navigationStateManager.resetToHome()
                }
                .font(
                Font.custom("Roboto", size: 20)
                .weight(.semibold)
                )
                .padding()
                .background(Color(red: 0.94, green: 0.44, blue: 0.4))
                .foregroundColor(.white)
                .clipShape(Capsule())
                
            } // end of V
        } // end of Z

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
