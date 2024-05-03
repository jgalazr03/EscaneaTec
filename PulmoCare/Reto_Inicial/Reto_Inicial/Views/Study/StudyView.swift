//
//  StudyView.swift
//  Reto_Inicial
//
//  Created by Mumble on 19/04/24.
//

import SwiftUI

struct StudyView: View {
    @State private var enfermedades: [[String: Any]] = []
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationStack{
            VStack {
                
                HStack {
                    Image(systemName: "stethoscope")
                        .foregroundColor(.white)
                        .padding()
                    Text("Estudio")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: QuestionView(enfermedad: "Medicina General")) {
                        Text("Quiz!")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                    .buttonBorderShape(.roundedRectangle)
                    .cornerRadius(25)
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                
                if isLoading {
                    ProgressView("Cargando...")
                } else {
                    List {
                        ForEach(0..<enfermedades.count, id: \.self) { index in
                            let enfermedad = enfermedades[index]
                            if let nombre = enfermedad["nombre_enfermedad"] as? String,
                               let informacion = enfermedad["informacion"] as? String {
                                NavigationLink(destination: ResultView(predictionResult: (nombre, -1, informacion))) {
                                        HStack {
                                            Image(systemName: "info.circle")
                                            Text("\(nombre)")
                                        }
                                        .padding()
                                    }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .onAppear {
                loadEnfermedades()
            }
        }
    }

    private func loadEnfermedades() {
        UserService.shared.getStudyInfo { success, result in
            DispatchQueue.main.async {
                isLoading = false
                if success, let result = result {
                    enfermedades = result
                } else {
                    print("No se pudieron cargar las enfermedades.")
                }
            }
        }
    }
}

#Preview {
    StudyView() // Previsualización de la vista
}
