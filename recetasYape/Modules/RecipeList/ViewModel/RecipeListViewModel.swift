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
    internal var apiSession: APIService
    private var cancellables = Set<AnyCancellable>()

    @Published var showAlert = false
    @Published var storedRecipes: [RecipeEntity] = []
    var alertMessage = "Unknown error"

    private let viewContext: NSManagedObjectContext

    init(apiSession: APIService = APISession(),
         context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.apiSession = apiSession
        self.viewContext = context
        self.fetchRecipes()
    }

    func fetchRecipes() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            self.storedRecipes = try viewContext.fetch(fetchRequest)
            if self.storedRecipes.isEmpty {
                fetchRecipesFromAPI()
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Error fetching recipes: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }

    // En tu ViewModel, usa la instancia de APISession para realizar la solicitud
    private func fetchRecipesFromAPI() {
        let cancellable = apiSession.request(with: RecipeEndpoint.recipeList)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        var errorMessage = "Unknown error"
                        if case .apiError(let reason) = error {
                            errorMessage = reason
                        }
                        self?.alertMessage = errorMessage
                        self?.showAlert = true
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (recipes: [Recipe]) in
                DispatchQueue.main.async {
                    self?.saveRecipesToCoreData(recipes)
                    self?.fetchRecipesFromCoreData()
                }
            })
        cancellables.insert(cancellable)
    }


    private func saveRecipesToCoreData(_ recipes: [Recipe]) {
        recipes.forEach { recipe in
            let recipeEntity = RecipeEntity(context: viewContext)
            recipeEntity.id = UUID() // Or map correctly
            recipeEntity.nombre = recipe.nombre
            recipeEntity.descripcion = recipe.descripcion
            recipeEntity.imagenReceta = recipe.imagen
            recipeEntity.latitudReceta = recipe.latitudImagen
            recipeEntity.longitudReceta = recipe.longitudImagen
        }
        do {
            try viewContext.save()
        } catch {
            debugPrint("Error saving recipes: \(error)")
        }
    }

    private func fetchRecipesFromCoreData() {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        do {
            DispatchQueue.main.async {
                do {
                    self.storedRecipes = try self.viewContext.fetch(request) // Usa self.viewContext y self.storedRecipes
                } catch {
                    debugPrint("Error fetching recipes: \(error)")
                }
            }
        } catch {
            debugPrint("Error creating fetch request: \(error)")
        }
    }


}
