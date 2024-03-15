//
//  ContentView.swift
//  PruebaMLModel
//
//  Created by Jesus Alonso Galaz Reyes on 14/03/24.
//

import RealityKit
import RealityKitContent

import SwiftUI
import CoreML

struct ModeloMLView: View {
    @State private var image: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil
    @State private var predictionLabel: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Clasificador de Imágenes")
                    .font(.title2)
                    
                    .padding(.top, 40) // Ajusta este valor para bajar el título
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.7)

                Spacer()
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10) // Bordes redondeados de la imagen.

                if !predictionLabel.isEmpty {
                    Text(predictionLabel)
                        .font(.title2) // Tamaño de fuente del resultado.
                        .bold() // Texto en negrita.
                        .foregroundColor(.gray) // Color del texto.
                        .padding() // Padding alrededor del texto.
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Button(action: {
                    showingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.title)
                        Text("Seleccionar imagen")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(40)
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .lineLimit(1) // Asegura que el título se mantenga en una sola línea.
            .minimumScaleFactor(0.01) // Reduce la escala del título si no cabe.
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)

        // Convertir UIImage a CVPixelBuffer
        guard let pixelBuffer = inputImage.toCVPixelBuffer() else {
            print("Conversión a CVPixelBuffer falló")
            return
        }

        // Utilizar el modelo para clasificar la imagen
        do {
            let model = try iMikers_RayosX(configuration: MLModelConfiguration())
            let prediction = try model.prediction(image: pixelBuffer)

            DispatchQueue.main.async {
                // Usar la propiedad 'target' para obtener la etiqueta de predicción
                self.predictionLabel = prediction.target

                // Si también quieres mostrar la probabilidad de la predicción:
                if let probability = prediction.targetProbability[prediction.target] {
                    self.predictionLabel += " (\(probability))"
                }
            }
        } catch {
            print("Error al realizar la predicción: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
