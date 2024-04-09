//
//  ProfileView.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 3/26/24.
//

import SwiftUI
import PhotosUI
import Firebase

struct ProfileView: View {
    var nickname: String? // for preview
    var exampleimage: UIImage? // for preview
    
    @AppStorage("userNickname") private var userNickname: String = ""
    @AppStorage("userImage") private var userImagePath: String = ""
    
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var signInMethod: String = "Unknown"
    
    @State private var showingScoreGraph = false
    @StateObject private var historyViewModel = OneTypeTestHistoryViewModel()
    
    var body: some View {
        ZStack {
            // Background rectangle with rounded corners
            RoundedRectangle(cornerRadius: 60)
                .fill(Color(red: 0.87, green: 0.94, blue: 0.95))
                .frame(width: 350, height: 600)
                .shadow(radius: 10)
            //.edgesIgnoringSafeArea(.all)
            VStack {
                //Spacer().frame(height: 50)
                // Image display logic
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                        .overlay(
                            Text("Tap to select a picture")
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                
                Text("Hello, \(userNickname)")
                    .font(.title)
                    .padding(.top, 40)
                
                Text("Your Current CEFR level: B1")
                    .padding()
                
                Text("Sign-in method: Apple")
                    .padding()
                
                Button("Check Your Progress") {
                    showingScoreGraph = true // Show the score graph
                    historyViewModel.fetchHistoryWithScores() // Fetch scores
                }
                .padding()
                .background(Color(red: 0.94, green: 0.44, blue: 0.4))
                .foregroundColor(.white)
                .cornerRadius(10)
                
            } // VStack
        } // ZStack
        .sheet(isPresented: $showingImagePicker) {
            PhotoPicker(image: $image)
        }
        .sheet(isPresented: $showingScoreGraph) {
            ScoreGraphView(scores: historyViewModel.scores)
        }
        .onAppear {
            loadImage()
            fetchSignInMethod()
        }
        
    }
    
    func fetchSignInMethod() {
        if let user = Auth.auth().currentUser {
            let providerData = user.providerData
            signInMethod = providerData.first?.providerID ?? "Unknown"

            // Convert the providerID to a more user-friendly format if necessary
            if signInMethod == "apple.com" {
                signInMethod = "Apple"
            } else if signInMethod == "password" {
                signInMethod = "Email/Password"
            } else {
                signInMethod = "Unknown"
            }
        }
    }
    
    // Loading the image from the saved path
    func loadImage() {
        if let imagePath = UserDefaults.standard.string(forKey: "userImage"),
           let imageData = FileManager.default.contents(atPath: imagePath),
           let loadedImage = UIImage(data: imageData) {
            self.image = loadedImage
        }
    }
    
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            let itemProvider = results.first?.itemProvider
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.parent.image = image
                            self.saveImage(image)
                        }
                    }
                }
            }
        }

        func saveImage(_ image: UIImage) {
            if let data = image.jpegData(compressionQuality: 1.0) {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileName = UUID().uuidString + ".jpg"  // Unique name for each image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)

                do {
                    try data.write(to: fileURL)
                    UserDefaults.standard.set(fileURL.path, forKey: "userImage")  // Save the path to UserDefaults
                } catch {
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
    }

}




//#Preview {
//    ProfileView()
//}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(nickname: "Sample Nickname", exampleimage: UIImage(systemName: "person.fill"))
            .environment(\.locale, .init(identifier: "en"))
    }
}
