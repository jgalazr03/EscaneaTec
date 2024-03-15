//
//  ThreeDView.swift
//  Reto_Inicial
//
//  Created by Mumble on 01/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ThreeDView: View {
    var body: some View {
        Model3D(named: "Realistic_Human_Lungs", bundle: realityKitContentBundle)
            .scaleEffect(3.0)
    }
}

#Preview {
    ThreeDView()
}
