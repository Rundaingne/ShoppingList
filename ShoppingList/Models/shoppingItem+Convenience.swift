//
//  shoppingItem+Convenience.swift
//  ShoppingList
//
//  Created by Brooke Kumpunen on 3/15/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CoreData

//Remember, we already have our class definition. So, here we only need to create an extension and give our ShoppingItem a convenience initializer. We will have to make sure we use the context, as well as the name and isPurchased.

extension ShoppingItem {
    @discardableResult
    convenience init(name: String, isPurchased: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.isPurchased = isPurchased
    }
}
