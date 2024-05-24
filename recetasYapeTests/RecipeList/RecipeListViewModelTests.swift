//
//  RecipeListViewModelTests.swift
//  recetasYapeTests
//
//  Created by Sergio Luis Noriega Pita on 24/05/24.
//

import XCTest
import CoreData
@testable import recetasYape

class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    var mockAPIService: MockAPIService!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        mockAPIService = MockAPIService()
        mockContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mockContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Avoids conflicts during tests
        
        viewModel = RecipeListViewModel(apiSession: mockAPIService, context: mockContext)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockContext = nil
        
        super.tearDown()
    }
    
    func testFetchRecipes() {
        let recipes: [RecipeEntity] = [
            createRecipeEntity(id: UUID(), nombre: "Recipe 1"),
            createRecipeEntity(id: UUID(), nombre: "Recipe 2")
        ]
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        let mockFetchRequestResultController = MockFetchRequestResultController(result: recipes)
        mockFetchRequestResultController.fetchRequest = fetchRequest
        let mockPersistenceController = MockPersistenceController(result: mockFetchRequestResultController)
        viewModel = RecipeListViewModel(apiSession: mockAPIService, context: mockContext)

        viewModel.fetchRecipes()
        
        XCTAssertEqual(viewModel.storedRecipes.count, recipes.count)
        XCTAssertEqual(viewModel.storedRecipes.first?.nombre, "Recipe 1")
        XCTAssertEqual(viewModel.storedRecipes.last?.nombre, "Recipe 2")
    }
    
    func createRecipeEntity(id: UUID, nombre: String) -> RecipeEntity {
        let recipeEntity = RecipeEntity(context: mockContext)
        recipeEntity.id = id
        recipeEntity.nombre = nombre
        return recipeEntity
    }
    class MockAPIService: APIService {
        func request<T>(with endpoint: RecipeEndpoint) -> AnyPublisher<T, APIError> where T : Decodable {
            fatalError("Mock APIService not implemented")
        }
    }

    class MockFetchRequestResultController: NSFetchedResultsController<RecipeEntity> {
        let result: [RecipeEntity]
        
        init(result: [RecipeEntity]) {
            self.result = result
            super.init()
        }
        
        override func performFetch() throws {
            self.fetchedObjects = result
        }
    }
    class MockPersistenceController: PersistenceController {
        let result: MockFetchRequestResultController
        
        init(result: MockFetchRequestResultController) {
            self.result = result
            super.init(inMemory: true) // Use in-memory store for testing
        }
        
        override func fetchAllRecipeItems() -> [RecipeEntity] {
            return result.fetchedObjects ?? []
        }
    }
}
