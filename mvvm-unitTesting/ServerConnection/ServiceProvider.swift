//
//  ServiceProvider.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 09/03/24.
//

import Foundation



let appTimeoutInterval = TimeInterval(30)

enum ServiceError: Error {
    case InvalidRequest
    case DecodeError(decodeError:String)
    case InvalidResponse(invalidResponse:String)
    case UnknownError
    
    func getMessage() -> String {
        switch self {
        case .InvalidResponse (let message):
            return message
        case .DecodeError (let message):
            return message
        case .InvalidRequest:
            return "Invalid Request" //TODO: Add localizes string for this string value
        case .UnknownError:
            return "Unknown Error" //TODO: Add localizes string for this string value
        }
    }
}

struct ServerError: Codable {
    let error, errorDescription: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}

typealias ServiceCallback = (_ success:Bool,_ data:Any?,_ error:ServiceError?) -> Void
typealias ViewModelCallback = (_ success:Bool,_ error:String?) -> Void
