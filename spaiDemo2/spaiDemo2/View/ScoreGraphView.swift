//
//  ScoreGraphView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 4/2/24.
//

import SwiftUI

struct ScoreGraphView: View {
    var scores: [(Double, Double)]
    
    private let maxScore: Double = 40.0 // Assuming the max grammar score is 40
    private let graphHeight: CGFloat = 200.0
    private let lineWidth: CGFloat = 2.0
    private let grammarLineGradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
    private let relevanceLineGradient = LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        VStack {
            Text("Score Progress")
                .font(.headline)
                .padding()
            
            ZStack {
                GraphBackground(maxScore: maxScore, steps: 4, graphHeight: graphHeight)

                ScorePath(scores: scores.map { $0.0 }, maxScore: maxScore, graphHeight: graphHeight, lineGradient: grammarLineGradient)
                ScorePath(scores: scores.map { $0.1 }, maxScore: maxScore, graphHeight: graphHeight, lineGradient: relevanceLineGradient)
            }
            .frame(height: graphHeight)
            .padding(.horizontal)
        }
    }
}

struct ScorePath: View {
    var scores: [Double]
    let maxScore: Double
    let graphHeight: CGFloat
    let lineGradient: LinearGradient

    var body: some View {
        Path { path in
            for (index, score) in scores.enumerated() {
                let xPosition = (UIScreen.main.bounds.width / CGFloat(scores.count)) * CGFloat(index)
                let yPosition = graphHeight * CGFloat(1 - score / maxScore)

                if index == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                } else {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
        }
        .stroke(lineGradient, style: StrokeStyle(lineWidth: 2.0, lineJoin: .round))
        .shadow(radius: 3)
    }
}

// Background grid and labels for the graph
struct GraphBackground: View {
    let maxScore: Double
    let steps: Int
    let graphHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Horizontal lines
                for i in 0...(steps + 1) {
                    let yPosition = graphHeight - (graphHeight / CGFloat(steps + 1) * CGFloat(i)) // Inverted
                    path.move(to: CGPoint(x: 0, y: yPosition))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: yPosition))
                }
            }
            .stroke(Color.gray.opacity(0.3))
            
            // Y-axis labels
            ForEach(0...steps, id: \.self) { i in
                Text("\(Int(maxScore / Double(steps) * Double(i)))")
                    .font(.caption)
                    .position(x: geometry.size.width - 20, y: graphHeight - (graphHeight / CGFloat(steps) * CGFloat(i))) // Inverted
            }
        }
    }
}




//#Preview {
//    ScoreGraphView()
//}
struct ScoreGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreGraphView(scores: [
            (35, 25),
            (37, 28),
            (40, 30),
            (38, 27),
            (36, 26)
        ])
        .frame(height: 200)
    }
}

