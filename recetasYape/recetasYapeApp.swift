//
//  recetasYapeApp.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 15/05/24.
//

import SwiftUI

@main
struct recetasYapeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                debugPrint("active")
            case .inactive:
                debugPrint("inactive")
            case .background:
                debugPrint("background")
                DatabaseManager.shared.saveContext()
            @unknown default:
                fatalError()
            }
        }
    }
}


