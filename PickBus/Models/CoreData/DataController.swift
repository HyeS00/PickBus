//
//  DataController.swift
//  PickBus
//
//  Created by Jaehwa Noh on 2022/11/19.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            print("storeDescription: \(storeDescription)")
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }

            completion?()
        }
    }
}
