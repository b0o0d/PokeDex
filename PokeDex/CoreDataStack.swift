//
//  CoreDataStack.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokeDex")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreDataStack: Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("CoreDataStack: Unable to save context: \(error)")
            }
        }
    }
}
