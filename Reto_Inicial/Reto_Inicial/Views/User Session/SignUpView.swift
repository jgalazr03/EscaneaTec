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
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        
        ZStack {
            
            NavigationStack {
                VStack {
                    Spacer()
                    
                    Text("Create account")
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
                                
                    NavigationLink(destination: LogInView().onAppear {
                        registerUser()
                    }) {
                        Text("Sign Up")
                            .padding(.all)
                            .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                            .cornerRadius(30)
                            .ignoresSafeArea()
                            .padding(-20)
                            .foregroundColor(.white)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .padding()
                    .padding(.top, 5.0)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                 NavigationLink(destination: LogInView()) {
                     Image(systemName: "arrow.left")
                         .padding(.all)
                         .background(Color(red: 86/255, green: 59/255, blue: 117/255))
                         .cornerRadius(30)
                         .ignoresSafeArea()
                         .padding(-20)
                         .foregroundColor(.white)
                 })
            }
        }
    }
    
    func registerUser() {
        guard password == confirmPassword else {
            alertTitle = "Error"
            alertMessage = "Las contraseñas no coinciden."
            showingAlert = true
            return
        }

        UserService.shared.registerUser(email: email, username: username, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.alertTitle = "Registro Exitoso"
                    self.alertMessage = "El usuario ha sido registrado exitosamente."
                } else {
                    self.alertTitle = "Registro Fallido"
                    self.alertMessage = "Ha ocurrido un error al registrar el usuario."
                }
                self.showingAlert = true
            }
        }
    }

}


#Preview {
    SignUpView()
}
