//
//  QuizResultView.swift
//  CreateAccount_API
//
//  Created by Jesus Alonso Galaz Reyes on 09/04/24.
//

import SwiftUI

struct Score: Hashable {
    let puntuacion: Int
    let fecha: String
}

struct QuizResultView: View {
    @State private var scores: [Score] = []
    @State private var isLoading = true
    
    let usuarioId = UserDefaults.standard.integer(forKey: userInSessionID_Int)
    
    var body: some View {
        VStack {
            // Título de la vista
            //Text("Scores")
                //.font(.largeTitle)
                //.fontWeight(.bold)
                //.padding(.top, 80) // Ajusta este valor según necesites para mover el texto más arriba

            // Contenido principal
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        fetchScores()
                    }
            } else if !scores.isEmpty {
                VStack {
                    Spacer(minLength: 10) // Ajusta este valor para empujar todo hacia abajo según necesites
                    
                    HStack {
                        Spacer() // Añadido para centrar los contenidos en HStack
                        
                        // Sección de la última puntuación
                        VStack {
                            Text("Your Score!")
                                .font(.title)
                                .fontWeight(.bold)
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Text("\(scores.first?.puntuacion ?? 0)")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                )
                            Text(formatDate(isoDate: scores.first?.fecha ?? ""))
                                .font(.caption)
                        }
                        
                        Spacer() // Espaciador para dar separación entre las secciones
                        
                        // Sección de las últimas 3 puntuaciones
                        VStack(alignment: .leading) {
                            Text("Last scores")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 10) // Añade espacio debajo del título
                                .padding(.leading, 38) // Mueve ligeramente a la derecha
                            
                            ForEach(1..<min(scores.count, 4), id: \.self) { index in
                                scoreCapsule(score: scores[index])
                                    .frame(width: 200)
                                    .padding(.bottom, 5) // Añade espacio entre las cápsulas
                            }
                        }
                        
                        Spacer() // Añadido para centrar los contenidos en HStack
                    }
                    .padding(.horizontal) // Añade padding a los lados de HStack
                    .padding(.vertical, 160) // Añade más padding arriba y abajo para dar más espacio
                }
            } else {
                Text("No hay puntuaciones disponibles")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 30) // Ajusta el padding horizontal para que sea consistente
    }


    
    @ViewBuilder
    private func scoreCapsule(score: Score) -> some View {
        HStack {
            Text(formatDate(isoDate: score.fecha))
                .font(.caption)
            Spacer()
            Text("\(score.puntuacion)%")
                .font(.caption)
        }
        .padding()
        .background(Capsule().fill(Color.gray.opacity(0.2)))
        
    }
    
    func fetchScores() {
        UserService.shared.getLastScores(userId: usuarioId) { success, fetchedScores in
            if success, let fetchedScores = fetchedScores {
                var tempScores: [Score] = []
                for fetchedScore in fetchedScores {
                    if let puntuacion = fetchedScore["puntuacion"] as? Int,
                       let fecha = fetchedScore["fecha"] as? String {
                        let formattedDate = formatDate(isoDate: fecha)
                        let score = Score(puntuacion: puntuacion, fecha: formattedDate)
                        tempScores.append(score)
                    }
                }
                DispatchQueue.main.async {
                    self.scores = tempScores
                    self.isLoading = false
                }
            } else {
                print("Error al obtener los scores o datos no disponibles")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    func formatDate(isoDate: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate] // Set the format options to only include the date
        if let date = dateFormatter.date(from: isoDate) {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = "yyyy-MM-dd" // Set the format you want here
            return newFormatter.string(from: date)
        }
        return isoDate
    }

}

#Preview {
    QuizResultView()
}
