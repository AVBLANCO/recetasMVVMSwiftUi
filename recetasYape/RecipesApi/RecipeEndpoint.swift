//
//  RecipeEndpoint.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 19/05/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add other methods if necessary
}

protocol Endpoint {
    var url: URL { get }
    var method: HTTPMethod { get }
}

enum RecipeEndpoint: RequestBuilder {
    case recipeList

    var urlRequest: URLRequest {
        switch self {
        case .recipeList:
            //https://66340f2a9bb0df2359a0a1b3.mockapi.io/recetas
            let url = URL(string: "https://66340f2a9bb0df2359a0a1b3.mockapi.io/recetas")!
            return URLRequest(url: url)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .recipeList:
            return .get
        }
    }
}
