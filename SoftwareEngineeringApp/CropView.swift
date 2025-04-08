//
//  CropView.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 4/1/25.
//

import SwiftUI

struct CropView: View {
    @Binding var image: UIImage
    @Environment(\.presentationMode) var presentationMode
    
    @State private var cropRect = CGRect(x: 50, y: 50, width: 200, height: 200) // Default crop area
    
    var body: some View {
        VStack {
            Spacer()
            
            // Show the image with cropping guide
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                
                // Crop Overlay (Just for guidance)
                Rectangle()
                    .strokeBorder(Color.blue, lineWidth: 2)
                    .frame(width: cropRect.width, height: cropRect.height)
            }
            
            Spacer()
            
            // Buttons
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
                .padding()

                Spacer()
                
                Button("Crop") {
                    image = cropImage(image: image, to: cropRect)
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                .padding()
            }
            .padding()
        }
    }
    
    // Function to crop image
    func cropImage(image: UIImage, to rect: CGRect) -> UIImage {
        let scale = image.scale
        let scaledRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.width * scale,
            height: rect.height * scale
        )

        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return image }
        return UIImage(cgImage: cgImage, scale: scale, orientation: image.imageOrientation)
    }
}
