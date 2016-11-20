//
//  ViewController.swift
//  SchedFix
//
//  Created by Paul Colusso on 7/11/16.
//  Copyright © 2016 Paul Colusso. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let em = EventFixManager.sharedInstance
    
    @IBOutlet weak var eventsTable: NSTableView!
    @IBOutlet weak var filterText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        checkAuth()
        refresh()
    }
    
    func checkAuth() {
        if (!em.eventFixer.isAuthorised()) {
            let alert = NSAlert()
            alert.messageText = "Calendar Access required."
            alert.informativeText = "This app is not authorised to load your calendars. Please grant access via System Preferences"
            alert.addButton(withTitle: "Open System Preferences")
            alert.addButton(withTitle: "I'll Think About it")
            alert.alertStyle = .warning
            
            alert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
                if modalResponse == NSAlertFirstButtonReturn {
                    EventFixManager.sharedInstance.eventFixer.requestAuthorisation(completion: {_ in })
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {self.checkAuth()})
                }
            })
            
            eventsTable.reloadData()
        }
    }
    
    func refresh() {
        eventsTable.reloadData()
        filterText.stringValue = "Events found matching filter '\(em.filter)'"
    }
    
    override func dismissViewController(_ viewController: NSViewController) {
        refresh()
        super.dismissViewController(viewController)
    }
    
    @IBAction func tweakAction(_ sender: Any) {
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        refresh()
    }
    
    @IBAction func fixAction(_ sender: Any) {
        em.eventFixer.fixEvents()
        refresh()
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let events = em.eventFixer.listEvents()
        return events.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let events = em.eventFixer.listEvents()
        
        if let cell = tableView.make(withIdentifier: "EventCell", owner: tableView) as? NSTableCellView {
            cell.textField?.stringValue = events[row]
            return cell
        }
        
        return nil
    }
}
