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
            
            VStack{

                ZStack{
                    HStack {
                        Button {
                            } label: {
                                Text("PulmoCare")
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.borderedProminent)
                            .scaleEffect(1.5)
                            .frame(width: 310, height: 50)
                            .padding()
                }
                                    
                    HStack{
                        Spacer()
                        
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        }
                        .buttonBorderShape(.circle)
                        .scaleEffect(1.5)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 86/255, green: 59/255, blue: 117/255), lineWidth: 7)
                                .frame(width: 70, height: 70)
                        )
                    }
                    .padding(30)
                }
                
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button{
                        open(id: "ML")
                    }label: {
                        VStack{
                            Spacer()
                            Image("menu2")
                                .resizable()
                                .frame(width: 190, height: 245)
                                .cornerRadius(25)
                            Text("Subir Imagen")
                                .padding()
                                .font(.title)
                        }
                    }
                    .frame(width: 215, height: 325)
                    .buttonBorderShape(.roundedRectangle(radius: 30.0))
                    
                    Spacer()
                    
                    Button{
                        open(id: "Study")
                    }label: {
                        VStack{
                            Spacer()
                            Image("menu3")
                                .resizable()
                                .frame(width: 190, height: 245)
                                .cornerRadius(25)
                            Text("Estudio")
                                .padding()
                                .font(.title)
                        }
                    }
                    .frame(width: 215, height: 325)
                    .buttonBorderShape(.roundedRectangle(radius: 30.0))
                    
                    Spacer()
                    
                    Button{
                        open(id: "Stats")
                    }label: {
                        VStack{
                            Spacer()
                            Image("stats")
                                .resizable()
                                .frame(width: 190, height: 245)
                                .cornerRadius(25)
                            Text("Estadísticas")
                                .padding()
                                .font(.title)
                        }
                    }
                    .frame(width: 215, height: 325)
                    .buttonBorderShape(.roundedRectangle(radius: 30.0))
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button{
                        open(id: "ChatBot")
                    }label: {
                        Image("logoChat")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .buttonBorderShape(.circle)
                    .padding()
                    .overlay(
                        Circle()
                            .stroke(Color(red: 86/255, green: 59/255, blue: 117/255), lineWidth: 7)
                            .frame(width: 71, height: 71)
                    )
                    
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
