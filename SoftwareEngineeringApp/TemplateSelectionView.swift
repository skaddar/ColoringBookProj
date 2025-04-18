//
//  TemplateSelectionView.swift
//  SoftwareEngineeringApp
//
//  Created by Skylar Hawk on 4/8/25.
//

import SwiftUI

struct TemplateSelectionView: View {
    let templates = ["template1", "template2", "template3"] // image asset names - refer to Preview Assets for this

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Choose a Template")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                ForEach(templates, id: \.self) { templateName in
                    NavigationLink(destination: ColoringPageEditor(templateName: templateName)) {
                        Image(templateName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Templates")
    }
}
