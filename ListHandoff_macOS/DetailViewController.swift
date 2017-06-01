//
//  DetailViewController.swift
//  ListHandoff
//
//  Created by Steven Beyers on 6/1/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {
    
    @IBOutlet weak var detailLabel: NSTextField!
    
    var event: Event? {
        didSet {
            updateText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateText()
    }
    
    private func updateText() {
        var labelText = "No Time Selected"
        if let event = event {
            labelText = "Unable to determine time"
            
            if let timeString = event.timestamp?.description {
                labelText = timeString
            }
        }
        
        detailLabel?.stringValue = labelText
    }
    
}
