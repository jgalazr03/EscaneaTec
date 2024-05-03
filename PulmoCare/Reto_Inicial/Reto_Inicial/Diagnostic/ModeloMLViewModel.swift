//
//  ModeloMLViewModel.swift
//  Reto_Inicial
//
//  Created by Jesus Alonso Galaz Reyes on 23/04/24.
//

import Foundation
import SwiftUI
import CoreML
import Vision

class ModeloMLViewModel: ObservableObject {
    @Published var image: Image?
    @Published var classificationLabel: String = ""
    @Published var inputImage: UIImage?
    
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

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.classificationLabel = "Error: \(error.localizedDescription)"
                }
                return
            }
            self?.processResults(for: request)
        }

        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                self.classificationLabel = "Failed to perform classification.\n\(error.localizedDescription)"
            }
        }
    }

    func processResults(for request: VNRequest) {
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            DispatchQueue.main.async {
                self.classificationLabel = "Unable to classify image."
            }
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
