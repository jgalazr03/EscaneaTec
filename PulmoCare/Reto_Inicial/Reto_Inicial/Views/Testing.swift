//
//  Testing.swift
//  Reto_Inicial
//
//  Created by Mumble on 23/04/24.
//

import SwiftUI

struct Testing: View {
    
    @State var answer: String
    
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
                HStack{
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Detailed Analysis Result")
                        .font(.headline)
                }
                .frame(width: 250)
                Text("Detailed Analysis Result Detailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis Result")
                    .font(.body)
                    .padding()
                    .cornerRadius(10)
            }
            HStack{
                HStack{
                    Image(systemName: "chart.bar.fill")
                    Text("Classification:")
                        .font(.headline)
                }
                .frame(width: 250)
                Text("Detailed Analysis Result Detailed Analysis ResultDetailed Analysis Result Detailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis ResultDetailed Analysis Result")
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
    Testing(answer: "PINGA")
}
