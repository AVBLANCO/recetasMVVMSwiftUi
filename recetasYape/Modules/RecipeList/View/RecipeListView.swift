//
//  RecipeListView.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import SwiftUI

struct RecipeListView: View {
    @ObservedObject private var viewModel = RecipeListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.storedRecipes, id: \.id) { recipe in
                    NavigationLink(destination: DetailViewView(recipe: recipe)) {
                        RecipeRow(recipe: recipe)
                    }
                }
            }
            .navigationBarTitle("Recetas")
            .onAppear {
                self.viewModel.fetchRecipes()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct RecipeRow: View {
    var recipe: RecipeEntity

    var body: some View {
        HStack {
            AsyncImage(url: recipe.imagenReceta ?? "")
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(recipe.nombre ?? "")
                    .font(.headline)
                Text(recipe.descripcion ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding(8)
    }
}

struct AsyncImage: View {
    @ObservedObject private var imageLoader: ImageLoader
    var url: String

    init(url: String) {
        self.url = url
        self.imageLoader = ImageLoader()
        if let imageUrl = URL(string: url) {
            self.imageLoader.loadImage(from: imageUrl)
        }
    }

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint("Error al cargar la imagen:, \(error) ")
                DispatchQueue.main.async {
                    self.error = error
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "com.example.ImageLoader", code: -1,
                                         userInfo: [NSLocalizedDescriptionKey: "No data received"])
                }
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
