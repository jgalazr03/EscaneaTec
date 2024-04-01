//  QuestionView.swift
//  Reto_Inicial
//
//  Created by Ale Guevara on 27/03/24.
//

import SwiftUI

struct QuestionView: View {
    @State private var questionAndAnswers: (question: String, answers: [String])?
    @State private var selectedAnswer: Int?
    @State private var correctAnswer: Int?
    @State private var isAnswerCorrect: Bool = false
    @State private var currentQuestionIndex: Int = 1 // Indica el número actual de pregunta
    private let totalQuestions = 4 // Límite de preguntas
    @State private var progress: [(value: Double, color: Color)]
    
    private let openAIService = OpenAIService()
    
    init() {
        // Inicializar el array de progreso con valores iniciales de 0.0 y color verde
        _progress = State(initialValue: Array(repeating: (value: 0.0, color: .gray), count: totalQuestions))
    }

    var body: some View {
        VStack {
            // Indicador del número de pregunta
            HStack {
                Spacer()
                Text("\(currentQuestionIndex)/\(totalQuestions)")
                    .padding()
            }
            if let questionAndAnswers = questionAndAnswers {
                Text("Pregunta: \(questionAndAnswers.question)")
                    .font(.title)
                    .padding()
                ForEach(0..<questionAndAnswers.answers.count, id: \.self) { index in
                    Button(action: {
                        selectedAnswer = index
                        checkAnswer()
                    }) {
                        Text("Respuesta \(index + 1): \(questionAndAnswers.answers[index])")
                            .padding()
                            .background(backgroundForAnswer(index: index))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
                .disabled(selectedAnswer != nil) // Deshabilitar los botones después de seleccionar una respuesta
                Button(action: {
                    reiniciar()
                    generateQuestionAndAnswer() // Generar nueva pregunta y respuestas
                    currentQuestionIndex += 1
                }) {
                    Text("Siguiente pregunta")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                .disabled(currentQuestionIndex == totalQuestions) // Deshabilitar el botón cuando se alcanza el límite de preguntas
                
                HStack {
                    ForEach(progress.indices, id: \.self) { index in
                        ProgressView(value: progress[index].value, total: 1.0)
                            .tint(progress[index].color) // Cambiar el color dinámicamente
                            .padding()
                    }
                }
                
            } else {
                ProgressView("Loading question and answer...")
                    .padding()
            }
        }
        .onAppear {
            generateQuestionAndAnswer()
        }
    }

    func generateQuestionAndAnswer() {
        let preguntaYRespuesta = "Hazme una pregunta general de medicina y dame cuatro respuestas a dicha pregunta, tres deben ser incorrectas y una debe ser la correcta. Necesito que me lo des estrictamente en este formato: 'Pregunta\nRespuesta1\nRespuesta2\nRespuesta3\nRespuesta4\nNumeroDeRespuestaCorrecta'. Si agregas algo más a este formato, aunque sea solo un salto de línea adicional, tu mensaje no podrá ser procesado por el sistema y fallará. Un ejemplo explicito del formato que te pido es este: ¿Cuál es la función principal del hígado en el cuerpo humano?\nAyuda en la digestión produciendo bilis\nRegula el nivel de azúcar en sangre\nProduce y libera oxígeno a la sangre\nProducción de células rojas de la sangre\n2"
        
        // Crea un nuevo mensaje con la pregunta y la solicitud de respuesta combinadas
        let questionAndAnswerMessage = Message(id: UUID(), role: .system, content: preguntaYRespuesta, createAt: Date())
        
        // Envía el mensaje al servicio de ChatGPT para generar una pregunta y su respuesta
        Task {
            let response = await openAIService.sendMessage(messages: [questionAndAnswerMessage])
            print("Response received")
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("No se pudo recibir el mensaje")
                return
            }
            // Dividir el contenido del mensaje en pregunta y respuesta
            let components = receivedOpenAIMessage.content.components(separatedBy: "\n")
            print("Respuesta:", receivedOpenAIMessage.content)
            print("Components:", components)
            guard components.count == 6 else {
                print("Respuesta no válida recibida")
                return
            }
            
            // Obtener la pregunta y las respuestas
            let question = components[0]
            let answers = Array(components[1...4])
            // Obtener el número de la respuesta correcta
            guard let correctAnswerIndex = Int(components[5]) else {
                print("Número de respuesta correcta no válido")
                return
            }
            // Actualizar el estado de la pregunta, las respuestas y la respuesta correcta para mostrarlas en la vista
            await MainActor.run {
                questionAndAnswers = (question: question, answers: answers)
                correctAnswer = correctAnswerIndex - 1 // Restamos 1 porque los índices comienzan en 0
                selectedAnswer = nil // Reiniciar la selección de respuesta
                isAnswerCorrect = false // Reiniciar el estado de respuesta correcta
            }
        }
    }
    
    func checkAnswer() {
        // Verificar si la respuesta seleccionada es correcta
        isAnswerCorrect = selectedAnswer == correctAnswer
        updateProgress()
    }
    
    func backgroundForAnswer(index: Int) -> Color {
        if let selectedAnswer = selectedAnswer {
            if isAnswerCorrect && index == selectedAnswer {
                return .green // Cambiar a verde si la respuesta seleccionada es correcta
            } else if !isAnswerCorrect && index == selectedAnswer {
                return .red // Cambiar a rojo si la respuesta seleccionada es incorrecta
            } else if !isAnswerCorrect && index == correctAnswer {
                return .green // Marcar la respuesta correcta de verde cuando se selecciona una respuesta incorrecta
            }
        }
        return Color.clear
    }
    
    func reiniciar() {
        // Verificar si la respuesta seleccionada es correcta
        questionAndAnswers = nil
    }
    
    func updateProgress() {
        // Incrementar el progreso basado en si la respuesta es correcta o incorrecta
        let index = currentQuestionIndex
        let color: Color = isAnswerCorrect ? .green : .red
        progress[index - 1] = (value: 1.0, color: color)
    }

}
