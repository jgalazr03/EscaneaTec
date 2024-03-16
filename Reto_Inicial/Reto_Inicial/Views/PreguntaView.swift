//
//  PreguntaView.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI

struct PreguntaView: View {
            
    var body: some View {
            
        ZStack {
            
            Color(red: 27/255, green: 65/255, blue: 127/255)
            
            VStack {
                
                Spacer()
                
                Text("¿Cuál de las siguiente es una causa común de la neumonía?")
                    .font(.custom("Pridi-Medium", size: 30))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("a) Aspiración de líquidos o alimentos en los pulmones.")
                    .font(.custom("Pridi-Light", size: 25))
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: 700, height: 75))
                
                Spacer()
                
                Text("b) Infección por hongos.")
                    .font(.custom("Pridi-Light", size: 25))
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(.purple)
                        .frame(width: 700, height: 75))
                
                Spacer()
                
                Text("c) Infección bacteriana.")
                    .font(.custom("Pridi-Light", size: 25))
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(.green)
                        .frame(width: 700, height: 75))
                
                Spacer()
                
                Text("d) Exposición a ciertos químicos o toxinas.")
                    .font(.custom("Pridi-Light", size: 25))
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(.yellow)
                        .frame(width: 700, height: 75))
                
                Spacer()
                
                Image("progressBar")
                    .resizable()
                    .frame(width: 400, height: 40)
                    .padding()
                
            }
        }
        
    }
    
}

#Preview {
    PreguntaView()
}
