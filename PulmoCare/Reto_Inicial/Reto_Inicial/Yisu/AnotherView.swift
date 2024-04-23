//
//  AnotherView.swift
//  Reto_Inicial
//
//  Created by Jesus Alonso Galaz Reyes on 23/04/24.
//

import SwiftUI

struct AnotherView: View {
    @EnvironmentObject var viewModel: CombinedViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Button {
                } label: {
                    Text("Diagnóstico Final")
                        .font(.title)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
                .padding()
            HStack{
                if let detailedAnalysisResult = viewModel.detailedAnalysisResult {
                    HStack{
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("Detailed Analysis Result")
                            .font(.headline)
                    }
                    .frame(width: 250)
                    Text(detailedAnalysisResult)
                        .font(.body)
                        .padding()
                        .cornerRadius(10)
                } else {
                    Text("No detailed analysis result available.")
                        .font(.title)
                }
            }
            HStack{
                HStack{
                    Image(systemName: "chart.bar.fill")
                    Text("Classification:")
                        .font(.headline)
                }
                .frame(width: 250)
                Text(viewModel.classificationLabel)
                    .font(.body)
                    .padding() // Añadir espacio alrededor del texto
                    .cornerRadius(10) // Bordes redondeados
            }
            Spacer()
        }
        .transition(.opacity)
    }
}


#Preview {
    AnotherView().environmentObject(CombinedViewModel())
}
