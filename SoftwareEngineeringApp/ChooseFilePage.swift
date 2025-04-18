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
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Preview Carousel
                if !selectedImages.isEmpty {
                    Image(uiImage: selectedImages[currentIndex].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .transition(.scale)
                        .animation(.easeInOut, value: currentIndex)
                }

                // Buttons
                HStack(spacing: 30) {
                    // Pick from Library
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Gallery", systemImage: "photo.on.rectangle")
                            .padding()
                            .frame(width: 140)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .foregroundColor(.blue)
                            .font(.headline)
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

                    // Open Camera
                    Button(action: {
                        showCamera = true
                    }) {
                        Label("Camera", systemImage: "camera.fill")
                            .padding()
                            .frame(width: 140)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .foregroundColor(.green)
                            .font(.headline)
                    }
                }

                Spacer()
            }
            .padding()
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
                    withAnimation {
                        currentIndex = (currentIndex + 1) % selectedImages.count
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
            }
            .sheet(isPresented: $showConfirmView) {
                if let image = tempImage {
                    ConfirmImageView(image: image) { _ in
                        navigateToProcessing = true
                    }
                }
            }
        }
        .navigationTitle("New Coloring Page")
        .navigationBarTitleDisplayMode(.inline)
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

}

