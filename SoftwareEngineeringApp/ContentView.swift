//
//  ContentView.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 2/3/25.
//

import SwiftUI


struct ContentView: View {
    @State private var isFilePickerPresented = false
    @State private var selectedFileURL: URL?
    
    var body: some View {
        LandingPageView()  
    }
}

#Preview {
    ContentView()
}
