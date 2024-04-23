//
//  PreguntasView.swift
//  Reto_Inicial
//
//  Created by Mumble on 22/04/24.
//

import SwiftUI

struct PreguntasView: View {
    
    @EnvironmentObject var viewModel: CombinedViewModel
    
    @State private var questions: [String] = []
    @State private var answers: [String] = ["", "", ""]
    
    @State private var isLoading = true
    
    private let openAIService = OpenAIService()
    
    var body: some View {
        
        VStack {
            
            if isLoading {
                
                Spacer()
                ProgressView("Cargando preguntas...")
                    .padding()
                Spacer()
                
            } else {
                
                Text("Diagnóstico: Preguntas")
                    .font(.largeTitle)
                
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    if let image = viewModel.inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .cornerRadius(25)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400)
                            .padding()
                    } else {
                        Text("No image available")
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack{
                        
                        Spacer()
                        
                        ForEach(0..<questions.count, id: \.self) { index in
                            VStack{
                                Text(questions[index])
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.title3)
                                TextField("Escribe tu respuesta aquí", text: $answers[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding()
                            .background(Color(red: 227/255, green: 204/255, blue: 255/255).opacity(0.5))
                            .cornerRadius(20)
                            .shadow(radius: 25)
                        }
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                NavigationLink(destination: RespuestasView(preguntas: questions, respuestas: answers).environmentObject(viewModel)) {
                    Text("Submit")
                }
                .buttonBorderShape(.roundedRectangle)
                .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
                .scaleEffect(1.0)
                .disabled(answers.contains { $0.isEmpty })
                
                Spacer()
            }
        }
        .onAppear {
            generateQuestions()
        }
        
    }
    
    func generateQuestions() {
        
        let TresPreguntas = "Dame tres preguntas que le harías a un estudiante de medicina sobre esta interpretación de una radiografía: \(viewModel.$detailedAnalysisResult), sin mencionar en ningún momento que se trata de neumonía, ya que el objetivo de estas preguntas es que el estudiante vaya aprendiendo a como interpretar una radiografía. Necesito que me des las tres preguntas estrictamente en este formato: Pregunta1\nPregunta2\nPregunta3'. Si agregas algo más a este formato, aunque sea solo un salto de línea adicional, tu mensaje no podrá ser procesado por el sistema y fallará. Ejemplo de formato válido: ¿esta es la pregunta 1?\n¿esta es la pregunta 2?\n¿esta es la pregunta 3?"
        
        print(TresPreguntas)
        
        let message = Message(id: UUID(), role: .system, content: TresPreguntas, createAt: Date())
        
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
            guard components.count == 3 else {
                print("Respuesta no válida recibida")
                return
            }
            
            let preguntas = Array(components[0...2])

            await MainActor.run {
                questions = preguntas
                isLoading = false
            }
        }
    }
    
}

#Preview {
    PreguntasView()
}
