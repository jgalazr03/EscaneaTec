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
    @State private var currentQuestionIndex: Int = 0
    private let totalQuestions = 4
    @State private var progress: [(value: Double, color: Color)]
    @State private var totalScore: Int = 0 // Agregado para mantener la puntuación total
    @State private var showingScoreModal = false
    @State private var quizStarted = false
    
    @State private var correction = ""
    @State private var correctionWindow: Bool = false
    
    private let openAIService = OpenAIService()
    
    let enfermedad: String
    
    init(enfermedad: String) {
        self.enfermedad = enfermedad
        // Inicializar el array de progreso con valores iniciales de 0.0 y color verde
        _progress = State(initialValue: Array(repeating: (value: 0.0, color: .gray), count: totalQuestions))
    }

    var body: some View {
        VStack {
            // Muestra el botón "Start Quiz" cuando el quiz no ha comenzado
            if !quizStarted {
                Text("Tema: \(enfermedad)")
                    .font(.largeTitle)
                    .padding()
                Button(action: {
                    startQuiz()
                }){
                    Text("Empezar Quiz")
                        .foregroundColor(.white)
                }
                .scaleEffect(1.5)
                .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
                .padding(.bottom, 100)
            } else {
                // Indicador del número de pregunta y contenido del quiz
                VStack {
                    HStack {
                        Spacer()
                        Text("\(currentQuestionIndex)/\(totalQuestions)")
                            .padding()
                    }
                    Spacer()
                    // Solo muestra el contenido del quiz si hay preguntas y respuestas cargadas
                    if let questionAndAnswers = questionAndAnswers, currentQuestionIndex > 0 {
                        Text("\(questionAndAnswers.question)")
                            .font(.title)
                            .padding()
                            .lineLimit(nil)
                        Spacer()
                        /*
                        if (correctionWindow){
                            Button(action: {

                            }) {
                                Text("!")
                            }
                        }
                         */
                        ForEach(0..<questionAndAnswers.answers.count, id: \.self) { index in
                            Button(action: {
                                selectedAnswer = index
                                checkAnswer()
                            }) {
                                Text("\(questionAndAnswers.answers[index])")
                                    .padding()
                                    .foregroundColor(.black)
                                    .frame(minWidth: 600)
                            }
                            .background(backgroundForAnswer(index: index))
                            .cornerRadius(25)
                            .frame(maxWidth: 600)
                        }
                        .disabled(selectedAnswer != nil) // Deshabilitar botones después de seleccionar una respuesta

                        Spacer()
                        Button(action: {
                            if currentQuestionIndex < totalQuestions {
                                reiniciar()
                                generateQuestionAndAnswer() // Generar nueva pregunta y respuestas
                                currentQuestionIndex += 1
                            }
                        }) {
                            Text(currentQuestionIndex == totalQuestions ? "Finalizar Quiz" : "Siguiente pregunta")
                                .padding()
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        .tint(Color(red: 86/255, green: 59/255, blue: 117/255))

                        Spacer()
                        HStack {
                            ForEach(progress.indices, id: \.self) { index in
                                ProgressView(value: progress[index].value, total: 1.0)
                                    .tint(progress[index].color) // Cambiar el color dinámicamente
                                    .scaleEffect(x: 1, y: 4)
                                    .padding()
                            }
                        }
                        Spacer()
                    } else {
                        ProgressView("Cargando pregunta y respuesta...")
                            .padding()
                        Spacer()
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingScoreModal) {
            ScoreModalView(score: totalScore, onDismiss: {
                // Reinicia el estado de la vista para un nuevo quiz
                self.resetQuiz()
            })
        }
    }


    func generateQuestionAndAnswer() {
        let preguntaYRespuesta = "Hazme una pregunta general de \(enfermedad) y dame cuatro respuestas a dicha pregunta, tres deben ser incorrectas y una debe ser la correcta. Necesito que me lo des estrictamente en este formato: 'Pregunta\nRespuesta1\nRespuesta2\nRespuesta3\nRespuesta4\nNumeroDeRespuestaCorrecta'. Si agregas algo más a este formato, aunque sea solo un salto de línea adicional, tu mensaje no podrá ser procesado por el sistema y fallará. Un ejemplo explicito del formato que te pido es este: ¿Cuál es la función principal del hígado en el cuerpo humano?\nAyuda en la digestión produciendo bilis\nRegula el nivel de azúcar en sangre\nProduce y libera oxígeno a la sangre\nProducción de células rojas de la sangre\n2"
        
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
        isAnswerCorrect = selectedAnswer == correctAnswer
        if isAnswerCorrect {
            // Asumiendo 25 puntos por respuesta correcta, ya que son 4 preguntas
            totalScore += 25
        }else{
            correctionWindow = true
        }
        updateProgress()
        
        // Verificar si estamos en la última pregunta y enviar la puntuación
        if currentQuestionIndex == totalQuestions {
            sendQuizScore()
        }
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
        return Color(red: 227/255, green: 204/255, blue: 255/255)
    }
    
    func reiniciar() {
        questionAndAnswers = nil
        correctionWindow = false
    }
    
    func updateProgress() {
        // Incrementar el progreso basado en si la respuesta es correcta o incorrecta
        let index = currentQuestionIndex
        let color: Color = isAnswerCorrect ? .green : .red
        progress[index - 1] = (value: 1.0, color: color)
    }
    
    func sendQuizScore() {
        //let userId = 1 // Ejemplo de userId hardcoded
        let userId = UserDefaults.standard.integer(forKey: userInSessionID_Int)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        UserService.shared.addQuizPuntuation(userId: userId, score: totalScore, date: formattedDate) { success in
            if success {
                print("Puntuación enviada con éxito")
            } else {
                print("Error al enviar la puntuación")
            }
        }
        showingScoreModal = true
    }
    
    func startQuiz() {
        quizStarted = true
        totalScore = 0
        currentQuestionIndex = 1
        progress = Array(repeating: (value: 0.0, color: .gray), count: totalQuestions)
        generateQuestionAndAnswer()
    }
    
    func resetQuiz() {
        quizStarted = false
        currentQuestionIndex = 0
        totalScore = 0
        questionAndAnswers = nil // Asegúrate de reiniciar esto para que no se muestre el último quiz
        progress = Array(repeating: (value: 0.0, color: .gray), count: totalQuestions)
        // No llamar a generateQuestionAndAnswer aquí para permitir que el usuario inicie el quiz manualmente
    }
    
    func generateCorrection(pregunta: String, respuesta: String) {
        let mensaje = "Para la siguiente pregunta: \(pregunta). ¿Por qué esta respuesta a esa pregunta es incorrecta?: \(respuesta)"
        
        // Crea un nuevo mensaje con la pregunta y la solicitud de respuesta combinadas
        let message = Message(id: UUID(), role: .system, content: mensaje, createAt: Date())
        
        // Envía el mensaje al servicio de ChatGPT para generar una pregunta y su respuesta
        Task {
            let response = await openAIService.sendMessage(messages: [message])
            print("Response received")
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("No se pudo recibir el mensaje")
                return
            }
            
            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
            await MainActor.run {
                correction = receivedMessage.content
            }
        }
    }

}

struct ScoreModalView: View {
    let score: Int
    var onDismiss: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Text("¡Fin del Quiz!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Tu puntuación es: \(score)")
                    .font(.title2)
                
                NavigationLink(destination: StatsView()) {
                    Text("Ver resultados")
                }
                .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                .foregroundColor(.white)
                .cornerRadius(25)
                
                Button("Cerrar"){
                    onDismiss()
                    presentationMode.wrappedValue.dismiss()
                }
                .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
            }
            .padding()
        }
    }
}

#Preview {
    QuestionView(enfermedad: "Pneumonia")
}
