//
//  ListTableDataSource.swift
//  ListHandoff
//
//  Created by Steven Beyers on 6/1/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

import CoreData

protocol ListTableDataSourceDelegate {
    func didSelect(event: Event?)
}

class ListTableDataSource: NSObject, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext? = nil
    var delegate: ListTableDataSourceDelegate?
    
    #if os(iOS)
    var tableView: UITableView?
    #else
    var tableView: NSTableView?
    #endif
    
    var currentActivity: NSUserActivity?
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.reloadData()
    }
    
    func numberOfObjects() -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func event(at row: Int) -> Event {
        return event(atIndexPath: IndexPath(item: row, section: 0))
    }
    
    func event(atIndexPath indexPath: IndexPath) -> Event {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func userDidSelect(event: Event?, notifyDelegate notify: Bool) {
        if notify {
            delegate?.didSelect(event: event)
        }

        if let event = event {
            // The user selected an event so we need to create a new activity
            let userInfo = ["timestamp": event.timestamp ?? NSDate()]
            
            if let existingActivity = currentActivity {
                // An activity already exists so we will just update it
                existingActivity.userInfo = userInfo
                existingActivity.needsSave = true
            } else {
                // we need to create a new activity
                currentActivity = NSUserActivity(activityType: "com.chariotsolutions.ListHandoff.viewTimestamp")
                currentActivity?.userInfo = userInfo
                currentActivity?.title = "View Timestamp"
            }
            
            currentActivity?.becomeCurrent()
        } else {
            // The user de-selected an event so we need to destroy the previous activity
            currentActivity?.invalidate()
            currentActivity = nil
        }
        
    }
}






















