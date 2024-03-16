//
//  ContentView.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        ZStack {
            
            Color(red: 27/255, green: 65/255, blue: 127/255)
            
            NavigationStack {
                VStack {
                    Spacer()

                    Text("ScaneaTEC")
                        .font(.system(size: 70))
                        .fontWeight(.bold)

                    // Usamos NavigationLink dentro de NavigationStack
                    NavigationLink{
                        LogInView()
                    }label:{
                        Text("GET STARTED")
                            .padding(.all)
                            .background(Color(red: 31/255, green: 191/255, blue: 255/255))
                            .cornerRadius(30)
                            .ignoresSafeArea()
                            .padding(-20)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title2)
                    }

                    Spacer()
                    
                    Text("by iMikers")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                }
                .edgesIgnoringSafeArea(.all)
                // Ocultar la barra de navegación
                .navigationBarHidden(true)
            }
            .padding()
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
        }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}


/*
 
 VStack {
     Model3D(named: "Scene", bundle: realityKitContentBundle)
         .padding(.bottom, 50)

     Text("Mike")

     Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
         .toggleStyle(.button)
         .padding(.top, 50)
 }
 
 */
