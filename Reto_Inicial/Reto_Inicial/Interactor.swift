
import Foundation

// Estructura Interactor que nos ayudará a cargar la información del JSON a nuestro programa
struct Interactor{
    // función loadCuestionario para crear el arreglo de Preguntas
    func loadCuestionario() throws -> [Pregunta]{ // se pone throws para indicar que muestre los errores
        
        // Obtener la URL del archivo JSON en el bundle principal
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json")
        else{ // Si no se puede obtener la URL, retornar un arreglo vacío y salir de la función
            return []
        }
        
        // Intentar cargar los datos desde la URL del archivo JSON
        let data = try Data(contentsOf: url)
        
        // Intentar decodificar los datos en un arreglo de objetos Pregunta
        return try JSONDecoder().decode([Pregunta].self, from: data)
    }
}
