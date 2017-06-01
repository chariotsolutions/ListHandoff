//
//  ListTableDataSource+macOS.swift
//  ListHandoff
//
//  Created by Steven Beyers on 6/1/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import Cocoa
import CoreData

extension ListTableDataSource: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return numberOfObjects()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let event = self.event(at: row)
        if let cell = tableView.make(withIdentifier: "listItemCell", owner: nil) as? NSTableCellView {
            var timestamp = "Unknown"
            if let time = event.timestamp?.description {
                timestamp = time
            }
            cell.textField?.stringValue = timestamp
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        var event: Event?
        
        if let selectedIndex = tableView?.selectedRow, selectedIndex >= 0 {
            event = self.event(at: selectedIndex)
        } else {
            print("nothing selected")
        }
        
        delegate?.didSelect(event: event)
    }
    
}
