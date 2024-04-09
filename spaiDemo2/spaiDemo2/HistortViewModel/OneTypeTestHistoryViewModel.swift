//
//  OneTypeTestHistoryViewModel.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 3/17/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct TestHistoryEntry: Identifiable, Codable {
    var id: String?
    var date: Date
    var testName: String
    var question: String
    var userAnswer: String
    var score: String
    var detailGrading: String
}


class OneTypeTestHistoryViewModel: ObservableObject {
    
    @Published var histories: [TestHistoryEntry] = []
    @Published var scores: [(Double, Double)] = []
    
    private var db = Firestore.firestore()

    func fetchHistory() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).collection("testHistory")
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    var fetchedHistories: [TestHistoryEntry] = []
                    for document in querySnapshot!.documents {
                        var historyEntry = try? document.data(as: TestHistoryEntry.self)
                        historyEntry?.id = document.documentID // Set the id to the document ID
                        if let historyEntry = historyEntry {
                            fetchedHistories.append(historyEntry)
                        }
                    }
                    DispatchQueue.main.async {
                        self.histories = fetchedHistories
                    }
                }
            }
    }



    func addHistoryEntry(_ entry: TestHistoryEntry) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        do {
            _ = try db.collection("users").document(userId).collection("testHistory").addDocument(from: entry)
        } catch {
            print(error)
        }
    }
    
    
    func fetchHistoryWithScores() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).collection("testHistory")
            .order(by: "date")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    var fetchedScores: [(Double, Double)] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let score = data["score"] as? String,
                           let grammarScore = self.extractScore(from: score, category: "Grammar"),
                           let relevanceScore = self.extractScore(from: score, category: "Relevance") {
                            fetchedScores.append((grammarScore, relevanceScore))
                        }
                    }
                    DispatchQueue.main.async {
                        self.scores = fetchedScores
                    }
                }
            }
    }

    private func extractScore(from scoreString: String, category: String) -> Double? {
        let pattern = "\(category): (\\d+)/"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: scoreString, range: NSRange(scoreString.startIndex..., in: scoreString)),
              let range = Range(match.range(at: 1), in: scoreString) else { return nil }
        return Double(scoreString[range])
    }

    
    
    
    
}
