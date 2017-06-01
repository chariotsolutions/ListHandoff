//
//  CoreDataHelper.swift
//  ListHandoff
//
//  Created by Steven Beyers on 5/31/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

import CoreData

class CoreDataHelper: NSObject {
    static private let instance = CoreDataHelper()
    
    class var shared: CoreDataHelper {
        get {
            return instance
        }
    }
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ListHandoff")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func insertNewObject() {
        let context = persistentContainer.viewContext
        let newEvent = Event(context: context)
        
        // If appropriate, configure the new managed object.
        newEvent.timestamp = NSDate()
        
        // Save the context.
        saveContext()
    }
    
    // MARK: - Core Data Saving support
 
#if os(iOS)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
#else
    func saveContext() {
        
    }
#endif
}
