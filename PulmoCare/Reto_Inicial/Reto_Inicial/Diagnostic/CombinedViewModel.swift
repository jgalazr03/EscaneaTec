//
//  CombinedViewModel.swift
//  Reto_Inicial
//
//  Created by Jesus Alonso Galaz Reyes on 23/04/24.
//

import Foundation
import SwiftUI
import UIKit
import CoreML
import Vision

class CombinedViewModel: ObservableObject {
    @Published var image: Image?
    @Published var inputImage: UIImage?
    @Published var classificationLabel: String = ""
    @Published var detailedAnalysisResult: String?
    
    @Published var isAnalysisComplete = false

    func loadImage() {
        guard let inputImage = self.inputImage else { return }
        image = Image(uiImage: inputImage)
        classifyImage(image: inputImage)
        analyzeImageGPT(image: inputImage) { [weak self] success in
            DispatchQueue.main.async {
                self?.isAnalysisComplete = success
            }
        }
    }

    private func classifyImage(image: UIImage) {
        guard let buffer = image.buffer(),
              let model = try? VNCoreMLModel(for: Pneumoniacoml(configuration: MLModelConfiguration()).model) else {
            DispatchQueue.main.async {
                self.classificationLabel = "Error loading model"
                print("Classification Error: \(self.classificationLabel)")
            }
            return
        }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.classificationLabel = "Error: \(error.localizedDescription)"
                    print("Classification Error: \(self?.classificationLabel ?? "Unknown error")")
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
                print("Classification Error: \(self.classificationLabel)")
            }
        }
    }

    private func processResults(for request: VNRequest) {
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            DispatchQueue.main.async {
                self.classificationLabel = "Unable to classify image."
                print("Classification Error: \(self.classificationLabel)")
            }
            return
        }

        DispatchQueue.main.async {
            self.classificationLabel = "\(topResult.identifier) with confidence of \(topResult.confidence * 100)%."
            print("Classification Result: \(self.classificationLabel)")
        }
    }

    private func analyzeImageGPT(image: UIImage, completion: @escaping (Bool) -> Void) {
        OpenAIService.shared.analyzeImage(image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let content):
                    self?.detailedAnalysisResult = content
                    completion(true)
                    print("GPT Analysis Result: \(content)")
                case .failure(let error):
                    self?.detailedAnalysisResult = nil
                    completion(false)
                    print("GPT Analysis Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
