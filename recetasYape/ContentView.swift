//
//  ContentView.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import SwiftUI
import CoreData


struct ContentView: App {
//    @Environment(\.managedObjectContext) private var viewContext
   
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
//            RecipeListView(viewModel: RecipeListViewModel)
            RecipeListView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                print("background")
                DatabaseManager.shared.saveContext()
            @unknown default:
                fatalError()
            }
        }
    }
    
    
}



//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
