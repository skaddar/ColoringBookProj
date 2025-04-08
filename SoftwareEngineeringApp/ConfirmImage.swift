//
//  ConfirmImage.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 4/1/25.
//

import SwiftUI

struct ConfirmImageView: View {
    @State var image: UIImage
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var isCropping = false // Toggles cropping
    var onConfirm: (UIImage) -> Void // Callback function for confirmed image

    var body: some View {
        NavigationView{
            VStack {
                // Display the selected image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding()
                
                Spacer()
                
                // Buttons
                HStack {
                    // Cancel Button (Goes back without saving)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                    }
                    
                    // Crop Button (Opens cropping tool)
                    Button(action: {
                        isCropping = true
                    }) {
                        Text("Crop")
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                    }
                    
                    // Confirm Button (Saves cropped image & redirects)
                    NavigationLink {
                        // destination view to navigation to
                        ImageProcessing()
                    } label: {
                        

                                Image(systemName: "Confirm")
                                        .foregroundColor(.gray)
                            
                            Text("Confirm")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                }
                .padding()
            }
        }
        .sheet(isPresented: $isCropping) {
            CropView(image: $image) // Calls our custom crop tool
        }
    }
}
