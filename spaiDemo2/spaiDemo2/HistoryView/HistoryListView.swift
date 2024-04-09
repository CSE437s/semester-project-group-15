//
//  HistoryListView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 3/17/24.
//

import SwiftUI

struct HistoryListView: View {
    @StateObject var viewModel = OneTypeTestHistoryViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 0.05, green: 0.8, blue: 0.76))
                        .frame(height: 170)
                        .cornerRadius(60, corners: [.bottomLeft, .bottomRight])
                        .edgesIgnoringSafeArea(.top)

                    Text("Test History")
                        .font(.title)
                        .foregroundColor(.white)
                    
                        
                } // ZStack
                ScrollView {
                    LazyVStack { // LazyVStack for better performance with many items
                        ForEach(viewModel.histories) { history in
                            NavigationLink(destination: OneTypeTestHistoryDetailView(historyEntry: history)) {
                                VStack(alignment: .leading) {
                                    Text("\(history.date, formatter: itemFormatter)")
                                        .font(.headline)
                                    Text("\(history.testName)")
                                        .font(.subheadline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    // Padding around the LazyVStack for spacing from edges
                    .padding()
                } // ScrollView
            } // VStack
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchHistory()
            }
        } // naviagtion view
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()



//#Preview {
//    HistoryListView()
//}
struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        // Creating a mock instance of the ViewModel with example data
        let viewModel = OneTypeTestHistoryViewModel()
        viewModel.histories = [
            TestHistoryEntry(date: Date(), testName: "Short Description Test", question: "Describe your favorite hobby.", userAnswer: "I love painting because...", score: "85", detailGrading: "Good vocabulary usage."),
            TestHistoryEntry(date: Date().addingTimeInterval(-86400), testName: "Listening Comprehension Test", question: "Summarize the main points of the lecture.", userAnswer: "The lecture was about...", score: "78", detailGrading: "Missed some key points.")
        ]

        return HistoryListView(viewModel: viewModel)
    }
}
