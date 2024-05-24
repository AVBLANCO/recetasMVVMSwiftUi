//
//  RecipeListViewTests.swift
//  recetasYapeTests
//
//  Created by Sergio Luis Noriega Pita on 24/05/24.
//

import XCTest
import SwiftUI
@testable import recetasYape 

class RecipeListViewTests: XCTestCase {
    
    func testRecipeListView() {
        let viewModel = RecipeListViewModel(apiSession: MockAPIService(), context: MockManagedObjectContext())
        let view = RecipeListView(viewModel: viewModel)
        let navigationView = view.body
        XCTAssertNotNil(navigationView)
    }
    

    
    class MockAPIService: APIService {
        func request<T>(with endpoint: RecipeEndpoint) -> AnyPublisher<T, APIError> where T : Decodable {
            fatalError("Not implemented")
        }
    }
    class MockManagedObjectContext: NSManagedObjectContext {
        override init(concurrencyType ct: NSManagedObjectContextConcurrencyType) {
            super.init(concurrencyType: ct)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
