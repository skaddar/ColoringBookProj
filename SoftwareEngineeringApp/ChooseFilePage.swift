import SwiftUI
import PhotosUI

// Structure to store identifiable images
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}


struct ChooseFilePage: View {
    
    @State private var selectedImages: [IdentifiableImage] = []
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var currentIndex: Int = 0
    @State private var showCamera = false
    @State private var showConfirmView = false
    @State private var tempImage: UIImage?
    @State private var navigateToProcessing = false


    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView{
            VStack {
                if !selectedImages.isEmpty {
                    Image(uiImage: selectedImages[currentIndex].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                
                // HStack for side-by-side buttons
                HStack(spacing: 15) { // Adjust spacing as needed
                    
                    // Choose File Button (Plain Text)
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Text("Choose File")
                            .foregroundColor(.blue)
                            .font(.system(size: 18, weight: .medium))
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                tempImage = image
                                showConfirmView = true
                            }
                        }
                    }
                    
                    
                    // Vertical Separator Line
                    Rectangle()
                        .frame(width: 1, height: 20)
                        .foregroundColor(.gray.opacity(0.5)) // Light gray line
                    
                    // Camera Button (Icon)
                    Button(action: {
                        showCamera = true
                    }) {
                        Image(systemName: "camera") // SF Symbol for camera
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // Smaller size
                            .foregroundColor(.blue) // Blue color to match text
                    }
                }
                .padding(.top, 10)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
            }
            .onAppear {
                if let assetImage1 = UIImage(named: "5666ed827c91085323c0cc78cc63fa82"),
                   let assetImage2 = UIImage(named: "Garden-Seeds"),
                   let assetImage3 = UIImage(named: "images") {
                    selectedImages = [
                        IdentifiableImage(image: assetImage1),
                        IdentifiableImage(image: assetImage2),
                        IdentifiableImage(image: assetImage3)
                    ]
                } else {
                    print("Error loading images from assets.")
                }
            }
            
            .onReceive(timer) { _ in
                if !selectedImages.isEmpty {
                    currentIndex = (currentIndex + 1) % selectedImages.count
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
            }
            .sheet(isPresented: $showConfirmView) {
                if let image = tempImage {
                    ConfirmImageView(image: image) {_ in 
                        navigateToProcessing = true
                        
                    }
                }
            }
            .padding()
        }
    }
}

// Camera View
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    ChooseFilePage()
}
