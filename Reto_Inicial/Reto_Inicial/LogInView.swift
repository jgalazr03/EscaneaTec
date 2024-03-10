//
//  LogInView.swift
//  Reto_Inicial
//
//  Created by Mumble on 29/02/24.
//

import SwiftUI

struct LogInView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        ZStack {
            
            Color(red: 27/255, green: 65/255, blue: 127/255)
            
            NavigationStack { // Asegúrate de que tu vista esté dentro de un NavigationStack
                VStack {
                    Spacer()
                    
                    Text("Inicio de sesión")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .frame(width: 400)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .frame(width: 400)
                    
                    NavigationLink(destination: LearningView()) {
                        Text("Login")
                            .padding(.all)
                            .background(Color(red: 31/255, green: 191/255, blue: 255/255))
                            .cornerRadius(30)
                            .padding(-20)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                            .ignoresSafeArea()
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .padding(.all)
                                .background(Color(red: 31/255, green: 191/255, blue: 255/255))
                                .cornerRadius(30)
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                          }
                      }
                      .padding(.bottom, 20)
                  }
                  .background(Color(UIColor.systemBackground))
                  .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
}

#Preview {
    LogInView()
}
