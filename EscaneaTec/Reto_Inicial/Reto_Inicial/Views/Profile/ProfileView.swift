//
//  ProfileView.swift
//  CreateAccount_API
//
//  Created by Jesus Alonso Galaz Reyes on 10/04/24.
//

import SwiftUI


struct ProfileView: View {
    @State private var username: String = ""
    @State private var email: String = ""

    
    // ID del usuario hardcodeado por ahora
    //let userId: String = "1"
    let userId = UserDefaults.standard.string(forKey: userInSessionID) ?? ""
    
    var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Imagen de perfil
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.vertical, 5)
                        
                        // Campo para el nombre de usuario
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true)
                            .padding(.horizontal, 345)
                        
                        // Campo para el correo electrónico
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true)
                            .padding(.horizontal, 345)
                            .padding(.bottom, 20)
                        
                        // Botón Cambiar Contraseña
                        NavigationLink(destination: ChangePasswordView(userId: userId)) {
                            Text("Change Password")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        
                        // Botón Cerrar sesión
                        Button(action: {
                            // Implementar cierre de sesión
                        }) {
                            Text("Sign out")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(10)
                                .padding(.horizontal, 57)
                        }
                        .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
                        
                    }
                        .padding(.top, 68)
                    .onAppear {
                        self.loadUserInfo()
                    }
                }
                .ignoresSafeArea()
                .padding(.bottom, 30)
                //.navigationBarTitle("Profile", displayMode: .inline)
            }
    }
    
    private func loadUserInfo() {
        UserService.shared.getUserInfo(userId: userId) { success, userInfo in
            if success {
                DispatchQueue.main.async {
                    self.username = userInfo?["username"] as? String ?? "Unknown"
                    self.email = userInfo?["email"] as? String ?? "Unknown"
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
