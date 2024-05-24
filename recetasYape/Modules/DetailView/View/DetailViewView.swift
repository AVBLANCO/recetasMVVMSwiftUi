//
//  DetailViewView.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 19/05/24.
//

import SwiftUI

struct DetailViewView: View {
    var recipe: RecipeEntity

    var body: some View {
        VStack {
            AsyncImage(url: recipe.imagenReceta ?? "")
                .frame(width: 200, height: 200)
                .cornerRadius(8)
                .padding()
            
            Text(recipe.nombre ?? "")
                .font(.largeTitle)
                .padding()
            
            Text(recipe.descripcion ?? "")
                .padding()
            
            if let latString = recipe.latitudReceta,
               let lonString = recipe.longitudReceta,
               let latitude = Double(latString),
               let longitude = Double(lonString) {
                NavigationLink(destination: viewMapView(latitude: latitude, longitude: longitude)) {
                    Text("Ver en el mapa")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Detalle de Receta")
    }
}
