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
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var isLoggedIn = false

    var body: some View {
        
        ZStack {
            
            NavigationStack {
                VStack {
                    Spacer()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    TextField("Username", text: $username)
                        .foregroundColor(Color.white)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .frame(width: 400)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(Color.white)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .frame(width: 400)
                
                    Text("Login")
                        .padding(.all)
                        .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                        .cornerRadius(30)
                        .ignoresSafeArea()
                        .padding(-20)
                        .foregroundColor(.white)
                        .onTapGesture {
                            loginUser()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        .padding()
                        .padding(.top, 5.0)
                    
                    NavigationLink(destination: MenuView(username: username), isActive: $isLoggedIn) {
                        EmptyView() // Enlace de navegación invisible
                    }
                    .hidden()

                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .padding(.all)
                                .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                                .cornerRadius(30)
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
    
    func loginUser() {
        UserService.shared.loginUser(login: username, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.alertTitle = "Inicio de sesión exitoso"
                    self.alertMessage = "¡Bienvenido \(self.username)!"
                    self.isLoggedIn = true
                } else {
                    self.alertTitle = "Fallo al iniciar sesión"
                    self.alertMessage = "Por favor, verifica tus credenciales e inténtalo de nuevo."
                }
                self.showingAlert = true
            }
        }
    }
}

#Preview {
    LogInView()
}
