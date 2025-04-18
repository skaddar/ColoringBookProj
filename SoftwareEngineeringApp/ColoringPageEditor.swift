import SwiftUI

struct ColoringPageEditor: View {
    let templateName: String
    @State private var selectedColor: UIColor = .red
    @State private var coloringImage: UIImage?
    @State private var filledImage: Image?

    let palette: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .brown, .black]

    var body: some View {
        VStack {
            if let image = filledImage {
                GeometryReader { geo in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let tapLocation = value.location

                                    let viewSize = geo.size
                                    let imageSize = coloringImage?.size ?? .zero

                                    let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
                                    let offsetX = (viewSize.width - imageSize.width * scale) / 2
                                    let offsetY = (viewSize.height - imageSize.height * scale) / 2

                                    let tapX = Int((tapLocation.x - offsetX) / scale)
                                    let tapY = Int((tapLocation.y - offsetY) / scale)

                                    if let baseImage = coloringImage {
                                        if let newImage = baseImage.floodFill(from: CGPoint(x: tapX, y: tapY), with: selectedColor) {
                                            coloringImage = newImage
                                            filledImage = Image(uiImage: newImage)
                                        }
                                    }
                                }
                        )
                }
                .frame(height: 400)
                .background(Color.gray.opacity(0.1))
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        if let img = UIImage(named: templateName) {
                            coloringImage = img
                            filledImage = Image(uiImage: img)
                        }
                    }
            }

            Divider()

            // Color Palette
            HStack(spacing: 12) {
                ForEach(palette, id: \.self) { color in
                    Circle()
                        .fill(Color(color))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                        )
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()

            Text("Tap on the image to fill a region.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Coloring Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}

