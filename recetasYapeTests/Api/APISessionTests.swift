//
//  APISessionTests.swift
//  recetasYapeTests
//
//  Created by Sergio Luis Noriega Pita on 24/05/24.
//

import XCTest
@testable import recetasYape

class APISessionTests: XCTestCase {
    
    func testValidResponse() {
        let mockData = Data("Mock response data".utf8)
        let mockEndpoint = RecipeEndpoint.mockEndpoint
        let session = URLSessionMock(data: mockData, response: HTTPURLResponse(url: mockEndpoint.url!, statusCode: 200, httpVersion: nil, headerFields: nil) , error: nil)
        
        let apiSession = APISession(session: session)
        
        let publisher: AnyPublisher<String, APIError> = apiSession.request(with: mockEndpoint)
        let expectation = XCTestExpectation(description: "Se espera una respuesta válida")
        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Se esperaba una respuesta válida, pero se obtuvo un error: \(error)")
            }
        }, receiveValue: { value in
        })
        
        wait(for: [expectation], timeout: 1.0)
        
        cancellable.cancel()
    }
    func testInvalidResponse() {
        let mockEndpoint = RecipeEndpoint.mockEndpoint
        
        let session = URLSessionMock(data: nil, response: HTTPURLResponse(url: mockEndpoint.url!, statusCode: 500, httpVersion: nil, headerFields: nil), error: nil)
        

        let apiSession = APISession(session: session)

        let publisher: AnyPublisher<String, APIError> = apiSession.request(with: mockEndpoint)

        let expectation = XCTestExpectation(description: "Se espera una respuesta inválida")
        

        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
 
                XCTFail("Se esperaba una respuesta inválida, pero la solicitud se completó con éxito")
            case .failure(let error):

                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }, receiveValue: { value in
            // No se espera ningún valor en este caso
        })
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
}

class URLSessionMock: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskMock()
        task.completionHandler = { completionHandler(self.data, self.response, self.error) }
        return task
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler?()
        }
    }
}
