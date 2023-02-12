//
//  NetworkPersistence.swift
//  KameBooks
//
//  Created by Jorge Suárez on 11/2/23.
//

import Foundation

final class NetworkPersistence {
    
    static let shared = NetworkPersistence()
    
    func getBooksList() async throws -> [BookModel] {
        try await checkResponse(request: .request(networkRequest: .getBooksList), type: [BookModel].self)
    }
    
    func createUser(user: UserModel) async throws {
        try await checkResponseVoid(request: .request(networkRequest: .createUser(user: user)))
    }
    
    /// Método para obtener un JSON lanzando una petición asíncrona y controlando los errores
    func checkResponse<T: Codable>(request: URLRequest,
                                   type: T.Type,
                                   decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            
            switch response.statusCode {
            case 200...300:
                print("✅ \(request.httpMethod ?? "") (\(response.statusCode)): \(request.url!)")
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print("🧠 Data: ", json ?? "No data")
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIErrors.json
                }
            case 400...1000:
                print("❌ \(request.httpMethod ?? "") (\(response.statusCode)): \(request.url!)")
                let dec = JSONDecoder()
                if let APIErrorCodeMessage = try? dec.decode(APIErrorCodeMessage.self, from: data) {
                    throw APIErrorCodeMessage
                } else {
                    throw DefaultError(messageDefault: "Error unknown \(response.statusCode)")
                }
                
            default:
                print("❌ \(request.httpMethod ?? "") (\(response.statusCode)): \(request.url!)")
                throw DefaultError(messageDefault: "Error unknown \(response.statusCode)")
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general
        }
    }
    
    /// Método para controlar una respuesta vacía con control de errores
    func checkResponseVoid(request: URLRequest) async throws -> Void{
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            
            switch response.statusCode {
            case 200...300:
                print("✅ \(request.httpMethod ?? "") (\(response.statusCode)): \(request.url!)")
                
            case 400...1000:
                print("❌ \(request.httpMethod ?? "") (\(response.statusCode)): \(request.url!)")
                throw DefaultError(messageDefault: "Error unknown \(response.statusCode)")
                
            default:
                print("❌ \(request.httpMethod ?? "") (\(response.statusCode)): \(request.url!)")
                throw DefaultError(messageDefault: "Error unknown \(response.statusCode)")
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general
        }
    }
}
