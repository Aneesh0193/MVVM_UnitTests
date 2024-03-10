//
//  APIEndPoint.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 10/03/24.
//

import Foundation


enum APIEndpoint {
    static let baseURL: String = "https://api.npoint.io"

    
    case catalogue
    
    var url: URL? {
        switch self {
        case .catalogue:
            return URL(string: "\(APIEndpoint.baseURL)/0f78766a6d68832d309d")
        }
    }
}
