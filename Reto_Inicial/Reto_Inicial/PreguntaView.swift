//
//  PreguntaView.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let respuesta: String
}

struct PreguntaView: View {
    
    let respuestas = [
        Question(respuesta: "Esta es la opción 1"),
        Question(respuesta: "Esta es la opción 2"),
        Question(respuesta: "Esta es la opción 3")
    ]
        
        @State private var multiSelection = Set<UUID>()
            
        var body: some View {
            ZStack {
                
                Color(red: 31/255, green: 191/255, blue: 255/255)
                
                VStack {
                    Text("Pregunta")
                        .padding(.leading, -600.0)
                        .padding()
                        .font(.title)
                        .foregroundColor(.white)
                    List(respuestas, selection: $multiSelection) { ans in
                        Text(ans.respuesta)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
}

#Preview {
    PreguntaView()
}
