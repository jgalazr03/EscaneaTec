//
//  OpenAIService.swift
//  ChatGPTApp
//
//  Created by Jesus Alonso Galaz Reyes on 14/03/24.
//

import Foundation
import Alamofire
import UIKit

class OpenAIService {
    static let shared = OpenAIService()
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"
    private let apiKey = Constants.openAIApiKey

    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content) })
        let body = OpenAIChatBody(model: "gpt-4", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)"
        ]
        return try? await AF.request(endpointUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }

    func analyzeImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not encode image"])))
            return
        }
        let base64Image = imageData.base64EncodedString()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let payload: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": "Interpreta todo lo que puedas de esta radiografía de pulmones para que al final puedas determinar si tiene neumonía o están sanos los pulmones."],
                        ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                    ]
                ]
            ],
            "max_tokens": 700
        ]

        AF.request(endpointUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let text = choices.first?["message"] as? [String: Any],
                   let content = text["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
