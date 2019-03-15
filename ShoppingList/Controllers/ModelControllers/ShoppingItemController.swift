//
//  ShoppingItemController.swift
//  ShoppingList
//
//  Created by Brooke Kumpunen on 3/15/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CoreData

class ShoppingItemController {
    
    //Things we need:
    
    //1) Singleton with private init
    static let shared = ShoppingItemController()
    private init() {}
    
    //2) Source of truth. In this case, that will be stored in the datamodel. I will need to create a fetchedresultscontroller to store all of this stuff.
    
    //3) CRUD I can only add and delete tasks. Only worry about those for here.
    func createItem(name: String) {
        ShoppingItem(name: name)
        saveToPersistence()
        
    }
    
    func deleteItem(item: ShoppingItem) {
        CoreDataStack.context.delete(item)
        saveToPersistence()
    }
    
    //4) Persistence and fetched results controller stuff
    func saveToPersistence() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving data. \(error): \(error.localizedDescription)")
        }
    }
    
}
