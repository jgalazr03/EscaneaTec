//
//  ContentView.swift
//  ChatGPTApp
//
//  Created by Jesus Alonso Galaz Reyes on 14/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Label {
                        Text("EscaneaTec")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 20)
                    } icon: {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.top, 20)
                    }
                }
                Spacer()
            }
            .padding()

            ScrollView {
                ScrollViewReader { scrollView in
                    ForEach(viewModel.messages.filter({ $0.role != .system }), id: \.id) { message in
                        messageView(message: message)
                            .padding(.horizontal)
                    }
                    .onChange(of: viewModel.messages) { _ in
                        if let lastMessageId = viewModel.messages.last?.id {
                            withAnimation {
                                scrollView.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }

            HStack {
                TextField("Enter a message...", text: $viewModel.currentInput)
                    .foregroundColor(.white)
                    .bold()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16) // Ajusta este valor según los márgenes que prefieras
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom) // Extiende el fondo negro hasta el borde inferior
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear.frame(height: 48) // Espacio adicional para el área de entrada de texto, ajusta según sea necesario
        }
    }

    func messageView(message: Message) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if message.role == .user {
                Spacer()
                VStack(alignment: .trailing) {
                    Label {
                        Text("User")
                            .foregroundColor(.white)
                            .bold()
                    } icon: {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(12)
                    .font(.caption)
                    .shadow(radius: 3)

                    Text(message.content)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(15)
                        .shadow(radius: 3)
                }
            } else if message.role == .assistant {
                VStack(alignment: .leading) {
                    Label {
                        Text("ChatBot")
                            .foregroundColor(.white)
                            .bold()
                    } icon: {
                        Image(systemName: "laptopcomputer")
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(12)
                    .font(.caption)
                    .shadow(radius: 3)

                    Text(message.content)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(15)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .padding(.leading, message.role == .user ? 50 : 16)
        .padding(.trailing, message.role == .assistant ? 50 : 16)
        .transition(.scale)
    }



}

#Preview {
    ChatView().preferredColorScheme(.dark)
}

