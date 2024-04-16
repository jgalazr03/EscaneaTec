//
//  ChangePasswordView.swift
//  CreateAccount_API
//
//  Created by Jesus Alonso Galaz Reyes on 11/04/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    var userId: String // Asumimos que este valor se pasa al inicializar la vista

    var body: some View {
        VStack {
            Spacer() // Empuja el contenido hacia el centro
            
            Text("Cambiar Contraseña")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            SecureField("Nueva contraseña", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .padding()
            
            SecureField("Confirmar contraseña", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .padding(.horizontal)
                .padding(.bottom, 30)
            
            Button("Submit") {
                guard newPassword == confirmPassword else {
                    alertMessage = "Las contraseñas no coinciden."
                    showAlert = true
                    return
                }
                
                UserService.shared.changeUserPassword(userId: userId, newPassword: newPassword) { success in
                    if success {
                        alertMessage = "Contraseña actualizada correctamente."
                    } else {
                        alertMessage = "Error al actualizar la contraseña."
                    }
                    showAlert = true
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            
            .padding(.bottom, 82)// Permite que el contenido anterior se centre verticalmente
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Cambio de Contraseña"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


//#Preview {
    //ChangePasswordView()
//}
