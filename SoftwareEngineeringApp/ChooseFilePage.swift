//
//  ChooseFileView.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 3/22/25.
//

import SwiftUI


struct ChooseFilePage: View {
    @State private var isFilePickerPresented = false
    @State private var selectedFileURL: URL?
    
    var body: some View {
        VStack {
            Button("Select a File") {
                isFilePickerPresented = true
            }
            .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.item], allowsMultipleSelection: false) { result in
                do {
                    selectedFileURL = try result.get().first
                } catch {
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
            
            if let fileURL = selectedFileURL {
                Text("Selected File: \(fileURL.lastPathComponent)")
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    ChooseFilePage()
}
