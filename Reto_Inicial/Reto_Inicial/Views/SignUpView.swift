//
//  SignUpView.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        
        ZStack {
            
            Color(red: 27/255, green: 65/255, blue: 127/255)
            
            NavigationStack { // Asegurándonos de que la vista esté dentro de un NavigationStack
                VStack {
                    Spacer()
                    
                    Text("Crear cuenta")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    // Campo de texto para el correo electrónico
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .frame(width: 400)
                    
                    // Campo de texto para el nombre de usuario
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .frame(width: 400)
                    
                    // Campo de texto para la contraseña
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .frame(width: 400)
                    
                    // Campo de texto para confirmar la contras
                    SecureField("Confirm Password", text: $confirmPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal, 40)
                                        .padding(.top, 10)
                                        .frame(width: 400)
                                    
                    // Botón de registro
                    NavigationLink(destination: LogInView()) {
                        Text("Sign Up")
                            .padding(.all)
                            .background(Color(red: 31/255, green: 191/255, blue: 255/255))
                            .cornerRadius(30)
                            .ignoresSafeArea()
                            .padding(-20)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                    .padding()
                    .padding(.top, 5.0)
                                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
}

#Preview {
    SignUpView()
}
