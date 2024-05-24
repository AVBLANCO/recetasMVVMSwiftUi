//
//  APIService.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation
import Combine
import UIKit

protocol APIService {
    func request<T: Decodable>(with endpoint: RecipeEndpoint) -> AnyPublisher<T, APIError>
}
