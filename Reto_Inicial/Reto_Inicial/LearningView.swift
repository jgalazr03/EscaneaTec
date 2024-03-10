//
//  LearningView.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct LearningView: View {
    
    @Environment(\.openWindow) private var open
    
    var body: some View {
            
        ZStack {
            
            Color(red: 27/255, green: 65/255, blue: 127/255)
            
            VStack {
                
                HStack {
                    
                    Spacer()
                
                    Button{
                        open(id: "quizz")
                    }label: {
                        Image(systemName: "book.circle")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 45))
                        .foregroundStyle(.white)
                    
                }
                .padding()
                
                Image("estudio")
                    .resizable()
                    .frame(width: 500, height: 500)
                
                Button{
                    open(id: "3D")
                }label: {
                    Text("Visualizar en 3D")
                }
                .padding()
                
                Spacer()
                
            }
            .ignoresSafeArea()
        }
            
    }
}

#Preview {
    LearningView()
}
