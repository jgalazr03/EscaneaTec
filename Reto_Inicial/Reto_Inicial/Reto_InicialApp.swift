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
            PreguntaView()
            PreguntaView()
        }
        
        WindowGroup(id: "3D") {
            ThreeDView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
