//
//  TweakViewController.swift
//  SchedFix
//
//  Created by Paul Colusso on 9/11/16.
//  Copyright © 2016 Paul Colusso. All rights reserved.
//

import Cocoa

class TweakViewController: NSViewController {

    @IBOutlet weak var eventField: NSTextField!
    @IBOutlet weak var calendarField: NSTextField!
    @IBOutlet weak var fixField: NSTextField!
    
    let em = EventFixManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        refresh()
    }
    
    @IBAction func calendarChanged(_ sender: Any) {
        em.calendar = calendarField.stringValue
    }
    @IBAction func eventChanged(_ sender: Any) {
        em.filter = eventField.stringValue
    }
    @IBAction func fixChanged(_ sender: Any) {
        em.fix = fixField.stringValue
    }
    
    func refresh() {
        calendarField.stringValue = em.calendar
        eventField.stringValue = em.filter
        fixField.stringValue = em.fix
    }
    
    @IBAction func resetAction(_ sender: Any) {
        em.reset()
        refresh()
    }
}
