//
//  ImageProcessing.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 3/30/25.
//
import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageProcessing: View {
    @State private var image: UIImage?
    @State private var processedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            if let processedImage = processedImage {
                // Display the processed coloring page
                Image(uiImage: processedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
            } else {
                Text("No image selected.")
                    .padding()
            }
            
            Button("Select Image") {
                showImagePicker = true
            }
            .padding()
            
            Button("Generate Coloring Page") {
                if let image = image {
                    processedImage = generateColoringPage(from: image)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    func generateColoringPage(from image: UIImage) -> UIImage {
        // Convert the UIImage to CIImage
        guard let ciImage = CIImage(image: image) else { return image }
        
        // Apply the edge detection filter (using inputIntensity instead of radius)
        let context = CIContext()
        let filter = CIFilter.edges()
        filter.inputImage = ciImage
        filter.intensity = 1.0  // This controls the strength of the edges
        
        // Get the output CIImage
        guard let outputImage = filter.outputImage else { return image }
        
        // Convert the CIImage to a UIImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
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
        picker.sourceType = .photoLibrary  // Set the source type to photo library
        picker.allowsEditing = false  // Prevents image cropping/editing
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    ImageProcessing()
}
