//
//  ResultView.swift
//  Reto_Inicial
//
//  Created by Emiliano Salinas on 11/04/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import CoreML


struct ResultView: View {
    let predictionResult: (String, Double)
    
    var body: some View {
        HStack {
            // Lado izquierdo: Modelo 3D
            Model3D(named: "Realistic_Human_Lungs", bundle: realityKitContentBundle)
                .scaleEffect(1.0)
                .frame(width: 400, height: 400) // Ajusta el tamaño según sea necesario
            
            // Lado derecho: VStack con información
            VStack(alignment: .leading, spacing: 20) {
                Text("Label: \(predictionResult.0)")
                    .font(.title)
                Text("Probabilidad: \(String(format: "%.2f", predictionResult.1))")
                    .font(.title)
                if predictionResult.0 == "PNEUMONIA" {
                    Text("La neumonía es una infección que inflama los sacos aéreos de uno o ambos pulmones. Los sacos aéreos pueden llenarse de líquido o pus (material purulento), lo que provoca tos con flema o pus, fiebre, escalofríos y dificultad para respirar.")
                        .font(.body)
                } else if predictionResult.0 == "NORMAL" {
                    Text("El resultado indica que los pulmones se encuentran en un estado normal, sin signos de neumonía u otras anomalías.")
                        .font(.body)
                }
            }
            .padding()
        }
        .navigationTitle("Resultado")
    }
}



struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(predictionResult: ("PNEUMONIA", 0.95))
    }
}
