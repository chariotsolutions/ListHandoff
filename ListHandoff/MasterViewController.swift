//
//  MasterViewController.swift
//  ListHandoff
//
//  Created by Steven Beyers on 5/31/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var dataSource = ListTableDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        dataSource.managedObjectContext = CoreDataHelper.shared.persistentContainer.viewContext
        dataSource.tableView = tableView
        dataSource.delegate = self
        tableView.delegate = dataSource
        tableView.dataSource = dataSource

        CoreDataHelper.shared.insertNewObject()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
        if clearsSelectionOnViewWillAppear {
            dataSource.userDidSelect(event: nil, notifyDelegate: false)
        }
        
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = dataSource.event(atIndexPath: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    func insertNewObject() {
        CoreDataHelper.shared.insertNewObject()
    }
}

extension MasterViewController: ListTableDataSourceDelegate {
    
    func didSelect(event: Event?) {
        if let event = event {
            let indexPath = dataSource.fetchedResultsController.indexPath(forObject: event)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            performSegue(withIdentifier: "showDetail", sender: event)
        }
    }
    
}

