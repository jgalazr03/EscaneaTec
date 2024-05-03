import SwiftUI

struct ModeloMLView: View {
    @StateObject private var viewModel = CombinedViewModel()
    @State private var showingImagePicker = false
    
    @State private var botonPresionado = false

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Subir Imagen de la Radiografía")
                    .font(.extraLargeTitle)
                    .foregroundStyle(.white)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    showingImagePicker = true
                    botonPresionado = true
                }) {
                    Text("Seleccionar Imagen")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .clipShape(Capsule())
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                .tint(Color(red: 86/255, green: 59/255, blue: 117/255))
                
                if botonPresionado == true && viewModel.isAnalysisComplete == false{
                    ProgressView("Cargando...")
                        .padding()
                }
                
                if viewModel.isAnalysisComplete {
                    NavigationLink(destination: PreguntasView().environmentObject(viewModel),
                                   isActive: $viewModel.isAnalysisComplete) {
                        Text("Empezar Práctica")
                            .foregroundColor(Color.black)
                            .padding()
                            .clipShape(Capsule())
                    }
                    .tint(Color(red: 190/255, green: 170/255, blue: 214/255))
                    .padding()
                    .disabled(!viewModel.isAnalysisComplete)
                }

                Spacer()
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: viewModel.loadImage) {
                ImagePicker(image: $viewModel.inputImage)
            }
            .padding()
        }
    }
}


struct ModeloMLView_Previews: PreviewProvider {
    static var previews: some View {
        ModeloMLView().environmentObject(CombinedViewModel())
    }
}
