//
//  HttpUtility.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 09/03/24.
//

import Foundation



protocol APIServiceProtocol {
    func getAPIData<T>(url: URL,decodeTo type: T.Type) async throws -> T where T: Decodable 
}

struct HttpUtility: APIServiceProtocol {
    
    let session: URLSession
    init (session: URLSession = .shared) {
        self.session = session
    }
    
    func getAPIData<T>(url: URL,decodeTo type: T.Type) async throws -> T where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.self, from: data)
                    return decoded
                } catch {
                    throw APIError.invalidResponse
                }
            case 400...499:
                if let error = try? JSONDecoder().decode(ServerError.self, from: data) {
                    throw APIError.serverError(error.errorDescription)
                } else {
                    throw APIError.invalidResponse
                }
            case 500...599:
                throw APIError.unknownError(httpResponse.statusCode)
            default:
                throw APIError.invalidResponse
            }
        }
    }
}




   

