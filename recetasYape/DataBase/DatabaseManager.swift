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
    
    // Store all recipe items fetched from network
    //    func addRecipeListItems(_ items: [RecipeListModel]) {
    //    func addRecipeListItems(_ items: [Recipe]) {
    //        // Clear all item before storing new
    //        deleteAllRecipeItems()
    //
    //        let _:[RecipeEntity] = items.compactMap { (recipe) -> RecipeEntity in
    //            let recipeitem = RecipeEntity(context: self.viewContext)
    ////            recipeitem.id    = Int32(Int(recipe.id ?? 0))
    //            recipeItem.id = UUID()
    //            recipeitem.nombre      = recipe.nombre
    //            recipeitem.descripcion    = recipe.descripcion
    //            recipeitem.imagenReceta  = recipe.imagen
    //            recipeitem.latitudReceta  = recipe.latitudImagen
    //            recipeitem.longitudReceta  = recipe.longitudImagen
    //
    //            return recipeitem
    //        }
    //
    //        saveContext()
    //    }
    
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
    
    // Ejemplo de Conversión de UUID basado en Int (No recomendado para IDs)
    
//    func addRecipeListItems(_ items: [Recipe]) {
//        deleteAllRecipeItems()
//        
//        items.forEach { recipe in
//            let recipeItem = RecipeEntity(context: self.viewContext)
//            if let id = recipe.id {
//                recipeItem.id = UUID(uuidString: String(format: "%08X-%04X-%04X-%04X-%012X", id, 0, 0, 0, 0)) ?? UUID()
//            } else {
//                recipeItem.id = UUID()
//            }
//            recipeItem.nombre = recipe.nombre
//            recipeItem.descripcion = recipe.descripcion
//            recipeItem.imagenReceta = recipe.imagen
//            recipeItem.latitudReceta = recipe.latitudImagen
//            recipeItem.longitudReceta = recipe.longitudImagen
//        }
//        
//        saveContext()
//    }
    
    
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
