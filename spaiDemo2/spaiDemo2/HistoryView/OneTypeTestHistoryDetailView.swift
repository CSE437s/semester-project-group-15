//
//  OneTypeTestHistoryDetailView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 3/17/24.
//

import SwiftUI

struct OneTypeTestHistoryDetailView: View {
    var historyEntry: TestHistoryEntry
    
    // Helper property to get the top safe area inset
    private var topSafeAreaInset: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        return window?.safeAreaInsets.top ?? 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Test Results")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            // Add top padding equal to the safe area's top inset
            // .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            // above gives warning "deprecated" so added helper and using the code below
            .padding(.top, topSafeAreaInset)
            
            
            ZStack {

                Rectangle()
                    .foregroundColor(.white)
                    //.frame(width: 393)
                    //.cornerRadius(60)
                    .cornerRadius(60, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Date: \(historyEntry.date, formatter: itemFormatter)")
                        .foregroundColor(Color(red: 0.94, green: 0.44, blue: 0.4))
                        .font(
                        Font.custom("Roboto", size: 20)
                        .weight(.medium)
                        )
                        .padding(.top, 30)
                    
                    ScrollView {
                        VStack {
                            Text("\(historyEntry.testName)")
                                .font(
                                Font.custom("Roboto", size: 20)
                                .weight(.black)
                                )
                                .foregroundColor(Color(red: 0, green: 0.51, blue: 0.65))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Score")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.94, green: 0.44, blue: 0.4))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        // Align this text to the top of the VStack
                                        .alignmentGuide(.leading) { dimension in
                                            dimension[.top]
                                        }
                                    Spacer() // This pushes the text to the top
                                }
                                .frame(width: 100)
                                
                                Rectangle()
                                    .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.77))
                                    .frame(width: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("\(historyEntry.score)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Question")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.94, green: 0.44, blue: 0.4))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        // Align this text to the top of the VStack
                                        .alignmentGuide(.leading) { dimension in
                                            dimension[.top]
                                        }
                                    Spacer() // This pushes the text to the top
                                }
                                .frame(width: 100)
                                
                                Rectangle()
                                    .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.77))
                                    .frame(width: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("\(historyEntry.question)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Your\nResponse")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.94, green: 0.44, blue: 0.4))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        // Align this text to the top of the VStack
                                        .alignmentGuide(.leading) { dimension in
                                            dimension[.top]
                                        }
                                    Spacer() // This pushes the text to the top
                                }
                                .frame(width: 100)
                                
                                Rectangle()
                                    .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.77))
                                    .frame(width: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("\(historyEntry.userAnswer)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Feedback")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.94, green: 0.44, blue: 0.4))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    // Align this text to the top of the VStack
                                    .alignmentGuide(.leading) { dimension in
                                        dimension[.top]
                                    }
                                    Spacer() // This pushes the text to the top
                                }
                                .frame(width: 100)
                                
                                Rectangle()
                                    .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.77))
                                    .frame(width: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("\(historyEntry.detailGrading)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()



                        }
                        .padding()
                        .padding(.bottom, 50)

                    } // scroll view
                    .padding()
                } // Vstack

            } // ZStack
            

            

        } // VStack
        .background(Color(red: 0.05, green: 0.8, blue: 0.76))
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()


//#Preview {
//    OneTypeTestHistoryDetailView()
//}
struct OneTypeTestHistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OneTypeTestHistoryDetailView(historyEntry: TestHistoryEntry(date: Date(), testName: "Short Description Test", question: "Describe your favorite hobby.", userAnswer: "I love painting because...", score: "85", detailGrading: "Good vocabulary usage."))
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
