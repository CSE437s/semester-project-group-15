//
//  HomeView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/27/24.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @AppStorage("userNickname") private var userNickname: String = ""
    @State private var selectedTestType: TestType?

//    let testTypes = [
//        ("Short Description", StartCountView(testType: .shortDescription)),
//        ("Sharing Experience", StartCountView(testType: .sharingExperience)),
//        ("Listening Comprehension", StartCountView(testType: .listeningComprehension)),
//        ("Expressing Opinion", StartCountView(testType: .expressingOpinion))
//    ]
    
    let testTypes: [(String, TestType)] = [
        ("Short Description", .shortDescription),
        ("Sharing Experience", .sharingExperience),
        ("Listening Comprehension", .listeningComprehension),
        ("Expressing Opinion", .expressingOpinion)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("SPAI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }

            Text("Hello, \(userNickname)")
                .font(.title)
                .padding(.bottom, 50)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 50) {
                    ForEach(testTypes, id: \.0) { testType in
                        Button(action: {
//                            selectedTestType = testType.1
                            self.navigationStateManager.selectedTestType = testType.1
                        }) {
                            Text(testType.0)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 200)
                                .background(Color.black)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                                .padding(.vertical, 20)
                        }
                    }
                }
                .padding(.horizontal, 50)
            }

            Spacer()
        }
        .fullScreenCover(item: self.$navigationStateManager.selectedTestType) { testType in
            StartCountView(testType: testType)
                .environmentObject(navigationStateManager)
        }
    }
}
    
 

struct RecShadowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.offWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            )
    }
}


extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}


//#Preview {
//    HomeView()
//}


//struct TestButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .clipShape(Capsule())
//            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
//    }
//}


//    var body: some View {
//        VStack {
//            HStack {
//                Text("SPAI")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding()
//                Spacer()
//            }
//
//            Text("Hello, \(userNickname)")
//                .font(.title)
//                .padding(.bottom, 50)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(alignment: .center, spacing: 50) {
//                    ForEach(Array(testTypes.enumerated()), id: \.offset) { index, testType in
//                        GeometryReader { geometry in
//                            NavigationLink(destination: testType.1) {
//                                Text(testType.0)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                    .frame(width: 200, height: 200)
//                                    .background(Color.black)
//                                    .cornerRadius(15)
//                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
//                                    .padding(.vertical, 20)
//                                    .rotation3DEffect(
//                                        Angle(degrees: Double(geometry.frame(in: .global).minX - 100) / -10),
//                                        axis: (x: 0.0, y: 1.0, z: 0.0)
//                                    )
//                            }
//                        }
//                        .frame(width: 200, height: 250)
//                    }
//                }
//                .padding(.horizontal, 50)
//            }
//
//            Spacer()
//        }
//    }
//}
