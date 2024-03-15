//
//  ChatGPTAppApp.swift
//  ChatGPTApp
//
//  Created by Jesus Alonso Galaz Reyes on 14/03/24.
//

import SwiftUI

@main
struct ChatGPTAppApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
