//
//  LandingPage.swift
//  SoftwareEngineeringApp
//
//  Created by soliman kaddar on 3/22/25.
//

import SwiftUI

struct LandingPageView: View {
    @State private var animateLogo = false
    @State private var showDrip = false
    @State private var dripY: CGFloat = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    // Dropper Icon + Drip
                    ZStack {
                        // Animated Dropper Icon
                        Image("MainIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(animateLogo ? -5 : 5), anchor: .top)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateLogo)
                            .onAppear {
                                animateLogo = true
                                startDripLoop()
                            }

                        // Drip Animation
                        if showDrip {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 12, height: 12)
                                .offset(y: dripY)
                                .opacity(1 - Double(dripY / 100))
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        dripY = 100
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        showDrip = false
                                        dripY = 0
                                        startDripLoop()
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 10)

                    // Title & Subtitle
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Turn your memories into coloring pages!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()

                    // CTA Button
                    NavigationLink(destination: HomeView()) {
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

                    Text("By continuing, you agree to our Terms & Privacy Policy.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                }
                .padding()
            }
        }
    }

    // Loop Drip with Delay
    func startDripLoop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showDrip = true
        }
    }
}

#Preview {
    LandingPageView()
}
