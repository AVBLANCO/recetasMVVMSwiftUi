//
//  RecipeListModel.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import Foundation

//struct RecipeListModel: Codable, Identifiable {
struct Recipe: Codable, Identifiable {
    let id : Int?
    let nombre: String?
    let imagen: String?
    let descripcion: String?
    let latitudImagen: String?
    let longitudImagen: String?
    
}
