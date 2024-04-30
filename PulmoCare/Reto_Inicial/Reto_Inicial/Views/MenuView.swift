import SwiftUI
import RealityKit
import RealityKitContent

let userInSessionID = "USER_ID";
let userInSessionID_Int = "USER_ID_INT"

struct MenuView: View {
    
    @Environment(\.openWindow) private var open
    
    @State var usuarioVM = UserService()
    var username: String
    
    var body: some View {
        
        NavigationStack{
            
            VStack {

                ZStack{
                    HStack {
                        Button {
                        } label: {
                            HStack(spacing: 0) {  // Establece el espaciado a 0 para evitar espacio entre las palabras
                                Text("Pulmo")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("Care")
                                    .font(.largeTitle)
                                    .foregroundColor(Color(red: 86/255, green: 59/255, blue: 117/255))
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .scaleEffect(1.5)
                        .frame(width: 310, height: 50)  // Asegúrate de que el ancho es suficiente
                        .padding(.top, 20)
                    }
                                    
                    HStack{
                        Spacer()
                        
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 34))
                        }
                        .buttonBorderShape(.circle)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 86/255, green: 59/255, blue: 117/255), lineWidth: 7)
                                .frame(width: 70, height: 70)
                        )
                    }
                    .padding(50)
                }
                .padding(.bottom, 25)
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button{
                        open(id: "ML")
                    }label: {
                        VStack{
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 100))
                            Text("Subir imagen")
                                .padding()
                                .font(.title)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(width: 300, height: 250)
                    .buttonBorderShape(.roundedRectangle(radius: 30.0))
                    
                    Spacer()
                    
                    Button{
                        open(id: "Study")
                    }label: {
                        VStack{
                            Spacer()
                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 100))
                            Text("Estudio")
                                .padding()
                                .font(.title)
                        }
                    }
                    .frame(width: 250, height: 250)
                    .buttonBorderShape(.roundedRectangle(radius: 30.0))
                    
                    Spacer()
                    
                    Button{
                        open(id: "Stats")
                    }label: {
                        VStack{
                            Spacer()
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 100))
                            Text("Estadísticas")
                                .padding()
                                .font(.title)
                        }
                    }
                    .frame(width: 250, height: 250)
                    .buttonBorderShape(.roundedRectangle(radius: 30.0))
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button{
                        open(id: "ChatBot")
                    }label: {
                        Image("chatgpt-green")
                            .resizable()
                            .scaledToFill()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    .buttonBorderShape(.circle)
                    .padding()
                    //.overlay(
                        //Circle()
                            //.stroke(Color(red: 86/255, green: 59/255, blue: 117/255), lineWidth: 7)
                            //.frame(width: 71, height: 71)
                    //)
                    Spacer() // Este Spacer empuja el botón hacia la izquierda.
                            .frame(width: 15) // Ajusta este valor para mover más o menos el botón hacia la izquierda.
                }
            }
            
        }
        .task {
            do {
                try await usuarioVM.getUserID(username: username)
                let userIDAsString = String(usuarioVM.userID)
                print("UserID obtenido:", userIDAsString)
                UserDefaults.standard.set(userIDAsString, forKey: userInSessionID)
                UserDefaults.standard.set(usuarioVM.userID, forKey: userInSessionID_Int)
            } catch {
                print("Error al llamar a getUserID")
            }
        }
        .ignoresSafeArea()
        .padding(.bottom, 20)
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(username: userInSessionID)
    }
}
