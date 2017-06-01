//
//  MasterViewController.swift
//  ListHandoff
//
//  Created by Steven Beyers on 6/1/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    var fetchedResultController: NSFetchedResultsController<Event>?
    var dataSource = ListTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataHelper.shared.insertNewObject()
        
        dataSource.managedObjectContext = CoreDataHelper.shared.persistentContainer.viewContext
        dataSource.delegate = self
        dataSource.tableView = tableView
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
}

extension MasterViewController: ListTableDataSourceDelegate {
    
    func didSelect(event: Event?) {
        if let splitView = parent as? NSSplitViewController, let detail = splitView.splitViewItems[1].viewController as? DetailViewController {
            detail.event = event
        }
    }
    
}
