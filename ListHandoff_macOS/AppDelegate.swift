//
//  AppDelegate.swift
//  ListHandoff_macOS
//
//  Created by Steven Beyers on 5/31/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return CoreDataHelper.shared.persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == NSAlertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
    
    // MARK: Handoff
    
    func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        // let iOS notify the user of any activity that is happening
        return false
    }
    
    func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        var handled = false
        
        if let date = userActivity.userInfo?["timestamp"] as? NSDate {
            let splitViewController = application.windows[0].contentViewController as? NSSplitViewController
            let master = splitViewController?.splitViewItems[0].viewController as? MasterViewController
            
            if let controller = master {
                let event = CoreDataHelper.shared.insertNewObject()
                event.timestamp = date
                
                controller.dataSource.userDidSelect(event: event, notifyDelegate: true)
                handled = true
            }
        }
        
        return handled
    }
    
    func application(_ application: NSApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        
        let alert = NSAlert()
        alert.messageText = "Unable to continue activity"
        alert.informativeText = error.localizedDescription
        alert.addButton(withTitle: "OK")
        
        _ = alert.runModal()
    }

}

