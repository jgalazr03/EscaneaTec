//
//  StatsView.swift
//  CreateAccount_API
//
//  Created by Jesus Alonso Galaz Reyes on 11/04/24.
//

import SwiftUI

struct StatsView: View {
    @State private var numberOfQuizzes: Int = 0
    @State private var averageScore: Double = 0.0
    @State private var maxScore: Int = 0
    @State private var minScore: Int = 0
    //let userId: String = "1"
    
    let userId = UserDefaults.standard.string(forKey: userInSessionID)
    
    var body: some View {
        VStack {
            Spacer(minLength: 20) // Espacio inicial

            // Primer HStack con los dos primeros bloques
            HStack {
                Spacer() // Espaciador antes del primer bloque para centrar
                statsBlock(title: "Quizzes completados", value: "\(numberOfQuizzes)")
                Spacer() // Espaciador entre los bloques
                statsBlock(title: "Puntuación media", value: String(format: "%.1f%%", averageScore))
                Spacer() // Espaciador después del segundo bloque para centrar
            }
            .padding(.horizontal) // Añade padding a los lados de HStack
            .padding(.vertical, 20) // Añade más padding arriba y abajo para dar más espacio

            // Segundo HStack con los dos últimos bloques
            HStack {
                Spacer() // Espaciador antes del primer bloque para centrar
                statsBlock(title: "Puntuación máxima", value: "\(maxScore)")
                Spacer() // Espaciador entre los bloques
                statsBlock(title: "Puntuación mínima", value: "\(minScore)")
                Spacer() // Espaciador después del segundo bloque para centrar
            }
            .padding(.horizontal) // Añade padding a los lados de HStack
            .padding(.vertical, 20) // Añade más padding arriba y abajo para dar más espacio

            Spacer() // Espacio final
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.loadUserQuizzesInfo()
        }
        
        //.ignoresSafeArea()
        //.padding(.bottom, 30)
    }
    
    @ViewBuilder
    private func statsBlock(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 120, height: 120)
                .overlay(
                    Text(value)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                )
        }
    }
    
    private func loadUserQuizzesInfo() {
        UserService.shared.getUserQuizzesInfo(userId: userId!) { success, result in
            guard success, let result = result else { return }
            
            DispatchQueue.main.async {
                if let quizzesCount = result["total_quizzes"] as? Int,
                   let averageScore = result["promedio_calificaciones"] as? Double,
                   let maxScore = result["puntuacion_maxima"] as? Int,
                   let minScore = result["puntuacion_minima"] as? Int {
                    self.numberOfQuizzes = quizzesCount
                    self.averageScore = averageScore
                    self.maxScore = maxScore
                    self.minScore = minScore
                }
            }
        }
    }
}

#Preview {
    StatsView()
}

