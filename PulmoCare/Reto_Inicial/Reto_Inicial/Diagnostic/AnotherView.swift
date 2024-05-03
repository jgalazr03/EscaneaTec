//
//  AnotherView.swift
//  Reto_Inicial
//
//  Created by Jesus Alonso Galaz Reyes on 23/04/24.
//

import SwiftUI

struct AnotherView: View {
    @EnvironmentObject var viewModel: CombinedViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 60) {
                titleButton()
                if let detailedAnalysisResult = viewModel.detailedAnalysisResult {
                    detailedAnalysisView(detailedAnalysisResult: detailedAnalysisResult)
                } else {
                    noResultView()
                }
                classificationView()
            }
            .padding(.horizontal)
            .transition(.opacity)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    @ViewBuilder
    private func titleButton() -> some View {
        Button(action: {
            // Acción del botón
        }) {
            Text("Diagnósticos Finales")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(ThemeColors.purple)
                .cornerRadius(10)
        }
        .buttonStyle(.borderedProminent)
        .tint(ThemeColors.purple)
    }
    
    @ViewBuilder
    private func detailedAnalysisView(detailedAnalysisResult: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            headerWithIcon(label: "Diagnósitoco de GPT 4", iconName: "chatgpt-green")
            Text(detailedAnalysisResult)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)  // Expand to use available width
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private func noResultView() -> some View {
        Text("No detailed analysis result available.")
            .font(.title2)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    private func classificationView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            headerWithIcon(label: "Diagnóstico de coML", iconName: "coML")
            Text(viewModel.classificationLabel)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)  // Expand to use available width
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
    
    @ViewBuilder
    private func headerWithIcon(label: String, iconName: String) -> some View {
        HStack {
            Image(iconName)
                .resizable()
                .frame(width: 24, height: 24)
            Text(label)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
    
    enum ThemeColors {
        static let purple = Color(red: 86/255, green: 59/255, blue: 117/255)
    }
}


// Preview for SwiftUI Canvas
struct AnotherView_Previews: PreviewProvider {
    static var previews: some View {
        AnotherView().environmentObject(CombinedViewModel())
    }
}

