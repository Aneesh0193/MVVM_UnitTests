//
//  APIClient.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 10/03/24.
//

import Foundation


protocol APIClientProtocol {
    func postResource<T: Decodable, E: Encodable>( to url: URL, body: E?, decodeTo type: T.Type) async throws -> T
}


//MARK: - APIClient
struct APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func postResource<T: Decodable, E: Encodable>( to url: URL, body: E?, decodeTo type: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        print(request)
        request.httpMethod = HTTPMethod.get.rawValue
        print(url)
        setHeaders(request: &request, token: "accessToken")
        
        do {
            let encoder = JSONEncoder()
            let requestData = try encoder.encode(body)
            request.httpBody = requestData
            
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

extension APIClient {
    func setHeaders(request: inout URLRequest, token: String) {
        request.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.addValue("\(AuthType.bearer.rawValue) \(token)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
    }
}
