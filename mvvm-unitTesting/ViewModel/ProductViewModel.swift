//
//  ProductViewModel.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 08/03/24.
//

import Foundation

//Method 1 -  CallBacks using Async/Await
class ProductViewModel {
    
    private var productResponse = Products()
    
    let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
 
    //MARK: - GetCataLogueData
    func getCataLogueData() async throws -> Products {
        guard let url = APIEndpoint.catalogue.url else {
            throw APIError.invalidURL
        }
        self.productResponse =  try await apiService.getAPIData(url: url, decodeTo: Products.self)
        
        return productResponse
    }
    
    //MARK: - GetNumberOfRowsInSections
    func getNumberOfRowsInSections() -> Int {
        return productResponse.products?.count ?? 0
    }
    
    //MARK: - GetData
    func getData(index: Int) -> Product? {
        return self.productResponse.products?[index]
    }
}


//Method 2: Callback using closure
//final class ProductViewModel {
//    //MARK: - Variables
//    var productResponse = [Product]()
//    var apiServiceProtocol: APIServiceProtocol
//    
//    init(apiService: APIServiceProtocol) {
//        self.apiServiceProtocol = apiService
//    }
//    
//    //MARK: - GetProductList
//    func getProductList(completion: @escaping ServiceCallback) {
//        guard let url = URL(string: URLCall.catalogue.rawValue) else { return }
//        
//        apiServiceProtocol.getAPIData(requestUrl: url, resultType: Products.self) { [weak self] success, data, error in
//            guard let response = data else {
//                return completion(false, nil, error)
//            }
//            
//            if let productList = response as? Products {
//                self?.productResponse = productList.products ?? []
//            }
//            completion(success, response, error)
//        }
//    }
//    
//    //MARK: - GetNumberOfRowsInSections
//    func getNumberOfRowsInSections() -> Int {
//        return productResponse.count
//    }
//    
//    //MARK: - GetData
//    func getData(index: Int) -> Product? {
//        return self.productResponse[index]
//    }
//}
