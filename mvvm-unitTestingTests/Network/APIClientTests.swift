//
//  APIClientTests.swift
//  mvvm-unitTestingTests
//
//  Created by Aneesh on 10/03/24.
//

import XCTest
@testable import mvvm_unitTesting

final class APIClientTests: XCTestCase {
    
    var sut = HttpUtility()
    var session: URLSession!
    var sutCatalogue = CatalogueViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        session = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }()
        
        sut = HttpUtility(session: session)
    }
    
    
    func testGetCatalogueAPICall() async throws  {
    
        guard let url = APIEndpoint.catalogue.url else { return }
        let products = Product(name: "BlueShirt",image: "https://firebasestorage.googleapis.com/v0/b/techtest-1f1da.appspot.com/o/blue.jpg?alt=media&token=5be5eadd-c006-4bb9-83af-d6afc496475a",price: 7.99,stock: 3,category: .tops, oldPrice: 8.99, productID: "1")
        let productData = Products(products: [products])
        let mockData =  try JSONEncoder().encode(productData)

        
        MockURLProtocol.requestHandler = { request in
            // Check the Http Request
            XCTAssertEqual(request.httpMethod!, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue), ContentType.json.rawValue)
            return (HTTPURLResponse(url: url, statusCode: 201, httpVersion: nil, headerFields: nil)!, mockData)
        }
        
        let expectation = expectation(description: "Get Resource Success")
        
        Task {
            do {
                let result = try await sut.getAPIData(url: url,decodeTo: Products.self)
                XCTAssertEqual(result.products?.first?.stock, 3)
                XCTAssertEqual(result.products?.first?.name, "BlueShirt")
                expectation.fulfill()
            } catch (let error) {
                XCTFail("An error occurred during the asynchronous call: \(error)")
                expectation.fulfill()
            }
        }
        
       await fulfillment(of: [expectation])
    }
    
    func testGetAPIServerError() async throws {
        guard let url = APIEndpoint.catalogue.url else { return }
        let jsonData = """
            {
                "error": "Invalid data",
                "error_description": "Invalide response"
            }
            """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!, jsonData)
        }
        
        let expectation = expectation(description: "server error respose")
        
        Task {
            do {
                _ = try await sut.getAPIData(url: url,decodeTo: Products.self)
                expectation.fulfill()
            } catch let error as APIError {
                switch error {
                case .serverError(let description):
                    XCTAssertEqual(description, "Invalide response")
                default:
                    XCTFail("The test should throw a server error for an error response.")
                }
                expectation.fulfill()
            }
            catch (let error) {
                XCTFail("An error occurred during the asynchronous call: \(error)")
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
