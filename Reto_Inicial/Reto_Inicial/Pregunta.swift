
// Modelo para almacenar cada tipo de pregunta en una estructura Pregunta

import Foundation

struct Pregunta: Codable, Identifiable, Hashable {
    let id: Int
    let pregunta: String
    let opciones: [String]
    let respuesta: String
}
