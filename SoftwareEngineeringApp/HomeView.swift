//
//  HomeView.swift
//  SoftwareEngineeringApp
//
//  Created by Skylar Hawk on 4/8/25.
//

import SwiftUI

struct HomeView: View {
    let coloringPages = Array(1...8).map { "Page \($0)" } // Placeholder data

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 10) {
                    // App Logo
                    Image(systemName: "paintpalette.fill") // Replace with your app logo if needed
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.top, 10)

                    // Welcome message
                    Text("Your Coloring Gallery")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)

                    // Grid of coloring pages
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(coloringPages, id: \.self) { page in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                                        .frame(height: 150)

                                    VStack {
                                        Image(systemName: "scribble.variable")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.blue)

                                        Text(page)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("My Coloring Pages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ChooseFilePage()) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

