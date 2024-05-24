//
//  RecipeListViewModel.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation
import CoreData
import Combine


class RecipeListViewModel: ObservableObject, RecipeApiService {
    var apiService: APIService
    
    var apiSession: APIService {
        return apiService
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var showAlert = false
    @Published var storedRecipes: [RecipeEntity] = []
    var alertMessage = "Unknown error"
    
    init(apiService: APIService = APISession()) {
        self.apiService = apiService
    }
    
    func fetchRecipes() {
        self.fetchRecipes()
            .sink(receiveCompletion: { [weak self] (result: Subscribers.Completion<APIError>) in
                switch result {
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (recipes: [Recipe]) in
                self?.saveRecipesToCoreData(recipes)
                self?.storedRecipes = self?.fetchRecipesFromCoreData() ?? []
            })
            .store(in: &cancellables)
    }
    
    private func saveRecipesToCoreData(_ recipes: [Recipe]) {
        let context = PersistenceController.shared.container.viewContext
        recipes.forEach { recipe in
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.id = UUID() // Or map correctly
            recipeEntity.nombre = recipe.nombre
            recipeEntity.descripcion = recipe.descripcion
            recipeEntity.imagenReceta = recipe.imagen
            recipeEntity.latitudReceta = recipe.latitudImagen
            recipeEntity.longitudReceta = recipe.longitudImagen
        }
        do {
            try context.save()
        } catch {
            print("Error saving recipes: \(error)")
        }
    }
    
    private func fetchRecipesFromCoreData() -> [RecipeEntity] {
        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching recipes: \(error)")
            return []
        }
    }
}
