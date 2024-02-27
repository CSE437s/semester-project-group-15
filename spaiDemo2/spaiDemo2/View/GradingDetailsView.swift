//
//  GradingDetailsView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/11/24.
//

import SwiftUI

struct GradingDetailsView: View {
    @EnvironmentObject var testViewModel: TestViewModel
    let feedback: String
    let detailedGrading: String

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
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    GradingDetailsView()
//}
