//
//  FullTestScoreView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 2/23/24.
// fixing

import SwiftUI

struct FullTestScoreView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TestViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Test Results")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)

                ForEach(Array(zip(viewModel.fullTestResponses.indices, viewModel.fullTestResponses)), id: \.0) { index, response in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(testTitle(for: index))
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("Your Response:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(response)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)

                        if index < viewModel.fullTestFeedbacks.count {
                            Text("Feedback:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(viewModel.fullTestFeedbacks[index])
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom)
                }

                Button("Return to Dashboard") {
                    viewModel.resetTestData()
                    navigationStateManager.returnToHomeFromFullTest()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .clipShape(Capsule())
                .padding(.top, 50)
            }
            .padding()
        }
    }

    private func testTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "Short Description Test"
        case 1:
            return "Sharing Experience Test"
        case 2:
            return "Listening Comprehension Test"
        case 3:
            return "Expressing Opinion Test"
        default:
            return "Test \(index + 1)"
        }
    }
}


struct FullTestScoreView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock TestViewModel with sample data for preview purposes
        let mockViewModel = TestViewModel()
        mockViewModel.fullTestResponses = [
            "This is a sample response for the Short Description Test.",
            "Here's what I think about sharing experiences.",
            "My thoughts on the listening comprehension section.",
            "My opinion on a given topic."
        ]
        mockViewModel.fullTestFeedbacks = [
            "Great use of vocabulary, but try to focus more on the main point.",
            "Excellent storytelling! Make sure to include more details next time.",
            "Good comprehension, but there were a few missed key points.",
            "Well-expressed opinion, but it lacked supporting arguments."
        ]

        // Create a mock NavigationStateManager for preview purposes
        let mockNavigationStateManager = NavigationStateManager()

        // Return the FullTestScoreView with the mock data
        return FullTestScoreView()
            .environmentObject(mockViewModel)
            .environmentObject(mockNavigationStateManager)
    }
}

//#Preview {
//    FullTestScoreView()
//}
