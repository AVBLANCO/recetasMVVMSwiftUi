//
//  DatabaseManager.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation
import CoreData
import SwiftUI


struct DatabaseManager {
    static let shared = DatabaseManager()
    
    private var viewContext = PersistenceController.shared.container.viewContext
    
    private init() {
    }

    
    func addRecipeListItems(_ items: [Recipe]) {
        // Clear all item before storing new
        deleteAllRecipeItems()
        
        items.forEach { recipe in
            let recipeItem = RecipeEntity(context: self.viewContext)
            recipeItem.id = UUID()
            recipeItem.nombre = recipe.nombre
            recipeItem.descripcion = recipe.descripcion
            recipeItem.imagenReceta = recipe.imagen
            recipeItem.latitudReceta = recipe.latitudImagen
            recipeItem.longitudReceta = recipe.longitudImagen
        }
        
        saveContext()
    }

    
    // Fetch all stored recipe items
    func fetchAllRecipeItems()->[RecipeEntity] {
        var result = [RecipeEntity]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeEntity.nombre, ascending: true)]
        do {
            if let all = try viewContext.fetch(request) as? [RecipeEntity] {
                result = all
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }
    
    // Delete all stored RecipeEntity items
    func deleteAllRecipeItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        do {
            if let all = try viewContext.fetch(request) as? [RecipeEntity] {
                for recipeItem in all {
                    viewContext.delete(recipeItem)
                }
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
