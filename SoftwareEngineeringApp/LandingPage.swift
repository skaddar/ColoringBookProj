//
//  LandingPage.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 3/22/25.
//

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        VStack {
            Spacer()
            
            
            // App Logo
            Image(systemName: "app.fill") // Replace with actual logo
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            // App Title
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Subtitle / Tagline
            Text("Turn your memories into coloring pages!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 5)
            
            Spacer()
            
            // Call-to-Action Button
            NavigationLink(destination: ContentView()) { // Replace with your main app view
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            
            // Terms & Privacy
            Text("By continuing, you agree to our Terms & Privacy Policy.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .padding(.bottom, 20)
        }
        .padding()
    }
}

#Preview {
    LandingPageView()
}


