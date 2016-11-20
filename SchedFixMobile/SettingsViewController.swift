//
//  SettingsViewController.swift
//  SchedFix
//
//  Created by Paul Colusso on 9/11/16. 
//  Copyright © 2016 Paul Colusso. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let em = EventFixManager.sharedInstance

    @IBOutlet weak var fixField: UITextField!
    @IBOutlet weak var eventField: UITextField!
    @IBOutlet weak var calendarField: UITextField!
    
    @IBAction func calendarEdited(_ sender: UITextField) {
        em.calendar = sender.text!
    }
    
    @IBAction func eventEdited(_ sender: UITextField) {
        em.filter = sender.text!
    }
    
    @IBAction func fixEdited(_ sender: UITextField) {
        em.fix = sender.text!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    @IBAction func switchAction(_ sender: Any) {
        let oldFix = fixField.text!
        let oldFilter = eventField.text!
        
        em.filter = oldFix
        em.fix = oldFilter
        
        refresh()
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        em.reset()
        refresh()
    }
    
    func refresh() {
        calendarField.text = em.calendar
        eventField.text = em.filter
        fixField.text = em.fix
    }
}
