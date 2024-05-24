//
//  RecipeEndpointTests.swift
//  recetasYapeTests
//
//  Created by Sergio Luis Noriega Pita on 24/05/24.
//

import XCTest

@testable import recetasYape

class RecipeEndpointTests: XCTestCase {
    
    func testRecipeListEndpoint() {
        let endpoint = RecipeEndpoint.recipeList
        let urlRequest = endpoint.urlRequest
        

        XCTAssertEqual(urlRequest.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://66340f2a9bb0df2359a0a1b3.mockapi.io/recetas")
    }
}
