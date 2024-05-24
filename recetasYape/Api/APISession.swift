//
//  APISession.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation
import Combine
import UIKit

struct APISession: APIService {
    func request<T: Decodable>(with endpoint: RecipeEndpoint) -> AnyPublisher<T, APIError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    return Fail(error: .apiError(reason: "Invalid response code: \(httpResponse.statusCode)")).eraseToAnyPublisher()
                }
                return Just(data)
                    .decode(type: T.self, decoder: decoder)
                    .mapError { error in
                        .parsingError(reason: error.localizedDescription)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
