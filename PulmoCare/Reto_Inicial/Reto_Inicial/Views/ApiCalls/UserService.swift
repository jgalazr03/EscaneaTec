//
//  UserService.swift
//  CreateAccount_API
//
//  Created by Jesus Alonso Galaz Reyes on 08/04/24.
//

import Foundation

class UserService {
    static let shared = UserService()
    var userID = Int()

    func registerUser(email: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://159.54.129.113:3000/users/register") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://159.54.129.113:3000/users/login") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = [
            "login": login,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func addQuizPuntuation(userId: Int, score: Int, date: String, completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "http://159.54.129.113:3000/users/quiz") else {
                completion(false)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let parameters = [
                "usuario_id": userId,
                "puntuacion": score,
                "fecha": date
            ] as [String : Any]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(false)
                return
            }

            URLSession.shared.dataTask(with: request) { _, response, _ in
                if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                    completion(true)
                } else {
                    completion(false)
                }
            }.resume()
        }
        
    func getLastScores(userId: Int, completion: @escaping (Bool, [[String: Any]]?) -> Void) {
        let urlString = "http://159.54.129.113:3000/users/lastscores/\(userId)"
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let jsonData = data else {
                completion(false, nil)
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                   let scoresArray = jsonObject["scores"] as? [[String: Any]] {
                    completion(true, scoresArray)
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, nil)
            }
        }.resume()
    }
    
    func changeUserPassword(userId: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://159.54.129.113:3000/users/changepw/\(userId)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = ["password": newPassword]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func getUserInfo(userId: String, completion: @escaping (Bool, [String: Any]?) -> Void) {
        guard let url = URL(string: "http://159.54.129.113:3000/users/userdata/\(userId)") else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let jsonData = data else {
                completion(false, nil)
                return
            }

            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    completion(true, jsonObject)
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, nil)
            }
        }.resume()
    }

    func getUserQuizzesInfo(userId: String, completion: @escaping (Bool, [String: Any]?) -> Void) {
        guard let url = URL(string: "http://159.54.129.113:3000/users/userquizzes/\(userId)") else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let jsonData = data else {
                completion(false, nil)
                return
            }

            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    completion(true, jsonObject)
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, nil)
            }
        }.resume()
    }
    
    //Alex
    func getUserID(username: String) async throws {
        guard let url = URL(string: "http://159.54.129.113:3000/users/getid/\(username)") else {
            print("URL inválida")
            return
        }
        print("PASO 1")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            print("PASO 2")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error en la respuesta")
                return
            }
            print("PASO 3")
            
            let decodedResponse = try JSONDecoder().decode(Respuesta.self, from: data)
            
            print("PASO 4")
            
            if let firstUserID = decodedResponse.userID.first {
                self.userID = firstUserID.id
                print("PASO 5")
            } else {
                print("No se encontró ningún ID de usuario para el nombre de usuario \(username)")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }



}
