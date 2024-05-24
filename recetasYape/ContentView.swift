//
//  ContentView.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import SwiftUI
import CoreData


struct ContentView: View {
    // Creamos una instancia de RecipeListViewModel
    @StateObject private var viewModel = RecipeListViewModel()

    var body: some View {
        // Pasamos la instancia de viewModel al inicializar RecipeListView
        RecipeListView(viewModel: viewModel)
    }
}
