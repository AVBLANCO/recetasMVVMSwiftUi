//
//  RecipeEndpoint.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 19/05/24.
//

import Foundation

enum RecipeEndpoint: RequestBuilder {
    case recipeList

    var urlRequest: URLRequest {
        switch self {
        case .recipeList:
            let url = URL(string: "https://66340f2a9bb0df2359a0a1bO3.mockapi.io/recetas")!
            return URLRequest(url: url)
        }
    }
}
