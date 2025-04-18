import UIKit

extension UIImage {
    func floodFill(from startPoint: CGPoint, with newColor: UIColor, tolerance: CGFloat = 0.05) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: cgImage.width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        context.draw(cgImage, in: rect)

        guard let pixelBuffer = context.data else { return nil }

        let pixelPtr = pixelBuffer.bindMemory(to: UInt32.self, capacity: cgImage.width * cgImage.height)
        let width = cgImage.width
        let height = cgImage.height

        let startX = Int(startPoint.x)
        let startY = Int(startPoint.y)
        guard startX >= 0, startX < width, startY >= 0, startY < height else { return nil }

        let oldColor = pixelPtr[startY * width + startX]
        let newColorInt = newColor.toUInt32()

        if oldColor == newColorInt { return self }

        var stack = [(x: Int, y: Int)]()
        stack.append((startX, startY))

        while !stack.isEmpty {
            let (x, y) = stack.removeLast()
            if x < 0 || x >= width || y < 0 || y >= height { continue }
            let index = y * width + x
            if pixelPtr[index] != oldColor { continue }

            pixelPtr[index] = newColorInt
            stack.append((x+1, y))
            stack.append((x-1, y))
            stack.append((x, y+1))
            stack.append((x, y-1))
        }

        guard let newCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
}

extension UIColor {
    func toUInt32() -> UInt32 {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let ri = UInt32(r * 255)
        let gi = UInt32(g * 255)
        let bi = UInt32(b * 255)
        let ai = UInt32(a * 255)

        return (ai << 24) | (ri << 16) | (gi << 8) | bi
    }
}

