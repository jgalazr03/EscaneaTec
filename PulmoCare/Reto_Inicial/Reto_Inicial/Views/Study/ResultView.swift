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
    let predictionResult: (String, Double, String)
    
    @Environment(\.openWindow) private var open
    
    var body: some View {
        
        NavigationStack{
            VStack {
                
                Spacer()
                
                HStack {
                    // Lado izquierdo: Modelo 3D
                    Model3D(named: "PROBAR", bundle: realityKitContentBundle)
                        .scaleEffect(1.0)
                        .frame(width: 400, height: 400) // Ajusta el tamaño según sea necesario
                    
                    // Lado derecho: VStack con información
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Enfermedad: \(predictionResult.0)")
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 86/255, green: 59/255, blue: 117/255))
                        if predictionResult.1 != -1 {
                            Text("Probabilidad: \(String(format: "%.2f", predictionResult.1))")
                                .font(.title3)
                        }
                        ScrollView{
                            Text("\(predictionResult.2)")
                                .font(.title3)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                NavigationLink(destination: QuestionView(enfermedad: predictionResult.0)) {
                    Text("Tomar Quiz")
                        .font(.body)
                        .foregroundColor(.white)
                }
                .buttonBorderShape(.roundedRectangle)
                .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
                .cornerRadius(25)
                
                Spacer()
                
            }
        }
        
    }
}



struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(predictionResult: ("PNEUMONIA", 0.95, "Descripción"))
    }
}
