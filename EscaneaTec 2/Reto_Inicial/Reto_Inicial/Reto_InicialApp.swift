//
//  Reto_InicialApp.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI

@main
struct Reto_InicialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(id: "quizz") {
            QuestionView()
        }
    }
}