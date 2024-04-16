//
//  Constants.swift
//  ChatGPTApp
//
//  Created by Jesus Alonso Galaz Reyes on 14/03/24.
//

import Foundation

enum Constants {
    static var openAIApiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("API key not found in environment variables")
        }
        return apiKey
    }
}
