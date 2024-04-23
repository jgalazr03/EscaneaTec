//
//  RespuestasView.swift
//  Reto_Inicial
//
//  Created by Mumble on 22/04/24.
//

import SwiftUI

struct RespuestasView: View {
    
    let preguntas: [String]
    let respuestas: [String]
    
    @EnvironmentObject var viewModel: CombinedViewModel
    
    @State private var isLoading = true
    
    @State private var retroalimentacion: [(calif: Int, comentario: String)] = [(0, ""), (0, ""), (0, "")]
    
    private let openAIService = OpenAIService()
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            ForEach(0..<preguntas.count, id: \.self) { index in
                HStack {
                    Spacer()
                    VStack(alignment: .leading){
                        Text(preguntas[index]) // Pregunta
                            .font(.title2)
                            .foregroundColor(Color(red: 86/255, green: 59/255, blue: 117/255))
                        Text(respuestas[index]) // Respuesta
                            .font(.title3)
                    }
                    .padding()
                    Spacer()
                    VStack{
                        if isLoading {
                            Spacer()
                            ProgressView("Cargando retroalimentación...")
                                .padding()
                            Spacer()
                        } else {
                            Text("Calificación: \(retroalimentacion[index].calif)/10") // Calificación
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(Color(red: 86/255, green: 59/255, blue: 117/255))
                            Text("Comentario: \(retroalimentacion[index].comentario)") // Comentario
                                .font(.title3)
                        }
                    }
                    .padding()
                    Spacer()
                }
                .background(Color.white.opacity(0.2)) // Fondo gris claro para cada bloque
                .cornerRadius(15)
            }
            
            Spacer()
            
            NavigationLink(destination: AnotherView().environmentObject(viewModel)) {
                Text("Ver Diagnóstico")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .buttonBorderShape(.roundedRectangle)
            .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
            .cornerRadius(25)
            
            Spacer()
            
        }
        .padding()
        .onAppear {
            chatProfe()
        }
        
    }
    
    func chatProfe() {
        
        let correccion = "Te voy a mostrar 3 preguntas, cada una con una respuesta, necesito que les des una calificación del 1 al 10 a cada una de las respuestas, la calificación depende de que tan correcta/acertada sea la respuesta a la pregunta. Además, da un comentario de retroalimentación a cada una de las respuestas, que le sea de utilidad al usuario. Necesito que me des las tres calificaciones y los 3 comentarios estrictamente en este formato: 'Calificación1\nRetroalimentación1\nCalificación2\nRetroalimentación2\nCalificación3\nRetroalimentación3'. Si agregas algo más a este formato, aunque sea solo un salto de línea adicional, tu mensaje no podrá ser procesado por el sistema y fallará. Las preguntas y respuestas son las siguientes: 1. Pregunta: \(preguntas[0]) Respuesta: \(respuestas[0]) 2. Pregunta: \(preguntas[1]) Respuesta: \(respuestas[1]) 3. Pregunta: \(preguntas[2]) Respuesta: \(respuestas[2]). Recuerda cumplir con el formato, este es un ejemplo de como debe ser: 9\nEste es mi comentario\n7\nEste es mi comentario\n10\nEste es mi comentario"
        
        let message = Message(id: UUID(), role: .system, content: correccion, createAt: Date())
        
        Task {
            let response = await openAIService.sendMessage(messages: [message])
            print("Response received")
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("No se pudo recibir el mensaje")
                return
            }

            let components = receivedOpenAIMessage.content.components(separatedBy: "\n")
            print("Respuesta:", receivedOpenAIMessage.content)
            print("Components:", components)
            guard components.count == 6 else {
                print("Respuesta no válida recibida")
                return
            }

            DispatchQueue.main.async {
                retroalimentacion[0] = (Int(components[0]) ?? 0, components[1])
                retroalimentacion[1] = (Int(components[2]) ?? 0, components[3])
                retroalimentacion[2] = (Int(components[4]) ?? 0, components[5])
                isLoading = false
            }
        }
    }
    
}
