import SwiftUI
import CoreML
import Vision

struct ModeloMLView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var classificationLabel: String = ""

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400, maxHeight: 400)
                    .shadow(radius: 10)

                if !classificationLabel.isEmpty {
                    formattedClassificationText(label: classificationLabel)
                        .padding(.horizontal)
                }
            }

            Spacer()
            
            Button(action: {
                showingImagePicker = true
            }) {
                Text("Select Image")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    //.background(Color.blue)
                    .clipShape(Capsule())
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .padding(.bottom, 50)
            .tint(Color.blue)
            
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
        .padding()
    }

    func formattedClassificationText(label: String) -> Text {
        let words = label.components(separatedBy: " ")
        var formattedText = Text("")
        for word in words {
            if word == "NORMAL" || word == "PNEUMONIA" {
                formattedText = formattedText + Text(word).bold() + Text(" ")
            } else {
                formattedText = formattedText + Text(word) + Text(" ")
            }
        }
        return formattedText.font(.title2)
    }

    func loadImage() {
        guard let inputImage = self.inputImage else { return }
        image = Image(uiImage: inputImage)
        classifyImage(image: inputImage)
    }

    func classifyImage(image: UIImage) {
        guard let buffer = image.buffer(),
              let model = try? VNCoreMLModel(for: Pneumoniacoml(configuration: MLModelConfiguration()).model) else {
            self.classificationLabel = "Error loading model"
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                self.classificationLabel = "Error: \(error.localizedDescription)"
                return
            }
            self.processResults(for: request)
        }

        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([request])
        } catch {
            classificationLabel = "Failed to perform classification.\n\(error.localizedDescription)"
        }
    }

    func processResults(for request: VNRequest) {
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            classificationLabel = "Unable to classify image."
            return
        }
        
        // Update UI on the main thread
        DispatchQueue.main.async {
            self.classificationLabel = "\(topResult.identifier) with confidence of \(topResult.confidence * 100)%."
        }
    }
}

extension UIImage {
    func buffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let width = 224
        let height = 224
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess, let pixelBuffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: CGFloat(height))
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        
        return pixelBuffer
    }
}

struct ModeloMLView_Previews: PreviewProvider {
    static var previews: some View {
        ModeloMLView()
    }
}



