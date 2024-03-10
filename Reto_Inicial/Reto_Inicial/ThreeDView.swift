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
        Model3D(named: "Pulmones", bundle: realityKitContentBundle)
            .scaleEffect(0.1)
    }
}

#Preview {
    ThreeDView()
}
