//
//  RecipeEntity+CoreDataProperties.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var nombre: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var imagenReceta: String?
    @NSManaged public var latitudReceta: String?
    @NSManaged public var longitudReceta: String?

}

extension RecipeEntity : Identifiable {

}
