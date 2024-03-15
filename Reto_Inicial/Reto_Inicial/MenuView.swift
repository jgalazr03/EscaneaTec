
import SwiftUI
import RealityKit
import RealityKitContent

struct Parallelogram: Shape {
    
    var depth: CGFloat
    var flipped: Bool = false
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            if flipped {
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: rect.width - depth, y: 0))
                p.addLine(to: CGPoint(x: rect.width, y: rect.height))
                p.addLine(to: CGPoint(x: depth, y: rect.height))
            } else {
                p.move(to: CGPoint(x: depth, y: 0))
                p.addLine(to: CGPoint(x: rect.width, y: 0))
                p.addLine(to: CGPoint(x: rect.width - depth, y: rect.height))
                p.addLine(to: CGPoint(x: 0, y: rect.height))
            }
            p.closeSubpath()
        }
    }
}

struct MenuView: View {
    
    @Environment(\.openWindow) private var open
    
    var body: some View {
            
        ZStack {
            
            Image("backgroundTech")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            NavigationStack{
                
                VStack{
                    
                    Text("PulmoCare")
                        .font(.custom("Philosopher-Bold", size: 50))
                        .foregroundStyle(.black)
                        .background(Rectangle()
                            .fill(.gray)
                            .frame(width: 400, height: 75))
                        .padding(.top, 75)
                    
                    Spacer()
                    
                    HStack{
                        
                        NavigationLink(destination: ChatView()) {
                            Text("ChatBot-GPT")
                                .padding(.all)
                                .background(Color(red: 234/255, green: 112/255, blue: 112/255))
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                          }
                        .mask(Parallelogram(depth: 13))
                        
                        NavigationLink(destination: ModeloMLView()) {
                            Text("Subir Imagen")
                                .padding(.all)
                                .background(Color(red: 241/255, green: 245/255, blue: 118/255))
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                          }
                        .mask(Parallelogram(depth: 13))
                        
                        NavigationLink(destination: StudyView()) {
                            Text("Study")
                                .padding(.all)
                                .background(Color(red: 142/255, green: 232/255, blue: 153/255))
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                          }
                        .mask(Parallelogram(depth: 13))
                        
                        Button{
                            open(id: "quizz")
                        }label: {
                            Text("Quiz")
                                .padding(.all)
                                .background(Color(red: 108/255, green: 192/255, blue: 218/255))
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        }
                        .mask(Parallelogram(depth: 13))
                        
                        Button{
                            open(id: "3D")
                        }label: {
                            Text("Modelo 3D")
                                .padding(.all)
                                .background(Color(red: 175/255, green: 106/255, blue: 232/255))
                                .ignoresSafeArea()
                                .padding(-20)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        }
                        .mask(Parallelogram(depth: 13))
                        
                    }
                    .padding(.bottom, 150)
                    
                }
                
            }
            
        }
            
    }
}

#Preview {
    MenuView()
}
