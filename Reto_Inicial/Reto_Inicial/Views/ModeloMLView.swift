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
        GeometryReader { geometry in
            HStack(alignment: .center) {
                // Lado izquierdo: Botón centrado
                VStack {
                    Spacer()
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
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width / 2, alignment: .center)

                // Lado derecho: Imagen y predicción, si están disponibles
                VStack {
                    Spacer()
                    if let image = image {
                        VStack {
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                                .offset(x: -85)

                            Text(predictionLabel)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black) // Color del texto ahora en negro
                                .padding()
                                .offset(x: -85)
                        }
                        .frame(width: geometry.size.width / 2)
                        .padding([.top, .horizontal])
                    } else {
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
        .edgesIgnoringSafeArea(.all)
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

struct ModeloMLView_Previews: PreviewProvider {
    static var previews: some View {
        ModeloMLView()
    }
}



