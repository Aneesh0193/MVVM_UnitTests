//
//  Product.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 08/03/24.
//

import Foundation


// MARK: - Products
struct Products: Hashable, Codable {
    
    var products: [Product]?
}
 
// MARK: - Product
struct Product: Hashable,Codable {
    
    var name: String?
    var image: String?
    var price: Float?
    var stock: Int16?
    var category: Category?
    var oldPrice: Float?
    var productID: String?
    var productQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case name, image, price, stock, category, oldPrice
        case productID = "productId"
    }
}

// MARK: -  Category
enum Category: String, Codable {
    case pants = "Pants"
    case shoes = "Shoes"
    case tops = "Tops"
}
// MARK: -  Cart
struct Cart: Codable {
    let cartId, productId: Int?
}
// MARK: - Result
struct Result: Decodable {

    let response: [Response]

    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }

    enum Response: Decodable {

        enum DecodingError: Error {
            case wrongJSON
        }

        case id(ID)
        case token(Token)
        case serverPublicKey(ServerPublicKey)

        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case token = "Token"
            case serverPublicKey = "ServerPublicKey"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch container.allKeys.first {
            case .id:
                let value = try container.decode(ID.self, forKey: .id)
                self = .id(value)
            case .token:
                let value = try container.decode(Token.self, forKey: .token)
                self = .token(value)
            case .serverPublicKey:
                let value = try container.decode(ServerPublicKey.self, forKey: .serverPublicKey)
                self = .serverPublicKey(value)
            case .none:
                throw DecodingError.wrongJSON
            }
        }
    }
}
// MARK: - ServerPublicKey
struct ServerPublicKey: Decodable {
    let serverPublicKey: String
    enum CodingKeys: String, CodingKey {
        case serverPublicKey = "server_public_key"
    }
}
// MARK: - Token
struct Token: Decodable {
    let token: String
    let updated: String
    let created: String
    let id: Int
}
// MARK: - ID
struct ID: Decodable {
    let id: Int
}
