//
//  RecipeApiService.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation
import Combine


protocol RecipeApiService {
    var apiSession: APIService { get }
    func fetchRecipes() -> AnyPublisher<[Recipe], APIError>
}

extension RecipeApiService {
    func fetchRecipes() -> AnyPublisher<[Recipe], APIError> {
        return apiSession.request(with: RecipeEndpoint.recipeList)
            .eraseToAnyPublisher()
    }
}
