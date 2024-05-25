
# recetasMVVMSwiftUi

is a project created in swift UI and in this project used the the architecture MVV. This project consume the api mock, generar modules like to RecipeList (Initial view in this view you found the  list of the recipes), detail view, view conteined the image, description and GPS values, and ViewMAp is the  view to gps map.




## Screenshots

![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)


## CoreData

```javascript
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = RecipeEntity(context: viewContext)
            newItem.id = UUID()
            newItem.nombre = "Receta de Ejemplo"
            newItem.descripcion = "Descripción de ejemplo"
            newItem.imagenReceta = "https://example.com/image.jpg"
            newItem.latitudReceta = "0.0"
            newItem.longitudReceta = "0.0"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "recetasYape")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
```


## Running Tests

Contained the unit test using XCTest in swfit, there are unite test to viewmodel and view:

- APISessionTests
- RecipeListViewModelTests
- RecipeListViewTests
- RecipeEndpointTests

## Structure

This project is used by the following structure to folders:

- Api:
    - APIError
    - APIService
    - APISession
    - RequestBuilder
- DataBase
    - DatabaseManager.swift
    - Persistence.swift
    - RecipeEntity+CoreDataClass.swift
    - RecipeEntity+CoreDataProperties.swift
-Modules:
    - MapView
        - view
    - DetailView:
        -view
    - RecipeList
        -Model 
        -ViewModel
        -view

- RecipesApi:
    - RecipeApiService.swift
    - RecipeEndpoint.swift
    - RecipeListModel


## Authors

- [@AVBLANCO](https://github.com/AVBLANCO)

