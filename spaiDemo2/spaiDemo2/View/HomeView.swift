//
//  HomeView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/27/24.
//

import SwiftUI
import Firebase

struct HomeView: View {
    var debugShowOnlyButtons: Bool = false // for preview
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @AppStorage("userNickname") private var userNickname: String = ""
    // ensure that TestViewModel is accessible from here and passed down to subsequent views.
    @StateObject private var testViewModel = TestViewModel()
    @State private var selectedTestType: TestType?
    @State private var showFullTest = false

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
            ZStack {
                VStack {
        //            HStack {
        //                Text("SPAI")
        //                    .font(.largeTitle)
        //                    .fontWeight(.bold)
        //                    .padding()
        //                Spacer()
        //            }

                    VStack(alignment: .leading) {
                        Text("Hello, \(userNickname)")
                            .font(Font.custom("Roboto", size: 30).weight(.black))
                            .foregroundColor(Color(red: 0, green: 0.51, blue: 0.65))
                            .padding(.top, 30)
                            // .font(.title)
                            // .padding(.bottom, 50)
                        
                        Text("Start your learning journey right now.")
                            .font(Font.custom("Roboto", size: 20).weight(.light))
                            .foregroundColor(.black)
                            .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    ZStack {
                        VStack {
                            Button(action: {
                                showFullTest = true
                            }) {
                                Text("Start Full Test")
                                    .font(Font.custom("Roboto", size: 20).weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 260, height: 50)
                                    .background(Color(red: 0.05, green: 0.8, blue: 0.76))
                                    .cornerRadius(30)
                                    // .background(Color.black)
                                    // .clipShape(Capsule())
                            }
                            .padding()
                            .fullScreenCover(isPresented: $showFullTest) {
                                FullTestStartCountView()
                                    .environmentObject(TestViewModel())
                                    .environmentObject(navigationStateManager)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(red: 0.87, green: 0.94, blue: 0.95))
                            .cornerRadius(60, corners: [.topLeft, .topRight])
                            .edgesIgnoringSafeArea(.all)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 50) {
                                ForEach(testTypes, id: \.0) { testType in
                                    Button(action: {
            //                            selectedTestType = testType.1
                                        self.navigationStateManager.selectedTestType = testType.1
                                    }) {
                                        VStack {
                                            Text("Start")
                                                .font(Font.custom("Roboto", size: 20).weight(.semibold))
                                                .foregroundColor(Color(red: 0.94, green: 0.44, blue: 0.4))
                                                .frame(width: 102, height: 50)
                                                .background(Color(red: 0.98, green: 0.79, blue: 0.77))
                                                .cornerRadius(25)
                                                .padding(.bottom, 20)
                                            
                                            Text(testType.0)
                                                .font(Font.custom("Roboto", size: 20).weight(.bold))
                                                .foregroundColor(.white)
                                                .padding(.bottom, 20)
                                            
                                        }
                                        .frame(width: 212.87311, height: 373) // Set the frame size
                                        .background( 
                                            Rectangle()
                                              .foregroundColor(.clear)
                                              .frame(width: 233, height: 331)
                                              .background(Color(red: 0.94, green: 0.44, blue: 0.4))
                                              .cornerRadius(30)
                                        )

                                    }
                                }
                            }
                            .padding(.horizontal, 50)
                        } // ScrollView
                    } // ZStack
                    Spacer()
                } // end of whole VStack

            } // end of whole ZStack

        
        .onChange(of: navigationStateManager.returnFromFullTestSession) { oldValue, newValue in
            if newValue {
                navigationStateManager.returnFromFullTestSession = false // Reset the flag
                showFullTest = false // Dismiss the FullTest session view
            }
        }
        
        .fullScreenCover(item: self.$navigationStateManager.selectedTestType) { testType in
            StartCountView(testType: testType)
                .environmentObject(navigationStateManager)
                .environmentObject(testViewModel) // Pass TestViewModel as an environment object
        }
        
    }
}
    
 

struct RecShadowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.94, green: 0.44, blue: 0.4))
//                    .fill(Color.offWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            )
    }
}



extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(debugShowOnlyButtons: true)
            .previewLayout(.sizeThatFits) // Use .sizeThatFits to focus on just the content
            .environmentObject(NavigationStateManager()) // If your buttons rely on the NavigationStateManager
    }
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
