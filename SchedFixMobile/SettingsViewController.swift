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
    @IBOutlet weak var calendarPicker: UIPickerView!
    @IBOutlet weak var calendarField: UILabel!
    
    var calendarPickerVisible = false
    
    @IBAction func eventEdited(_ sender: UITextField) {
        em.filter = sender.text!
    }
    
    @IBAction func fixEdited(_ sender: UITextField) {
        em.fix = sender.text!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendarPickerVisible = false
        calendarPicker.isHidden = true
        calendarPicker.translatesAutoresizingMaskIntoConstraints = false
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
    
    func showCalendarPicker() {
        self.calendarPickerVisible = true
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        self.calendarPicker.isHidden = false
        self.calendarPicker.alpha = 0.0
        UIView.animate(withDuration: 0.33, animations: { self.calendarPicker.alpha = 1.0 } )
    }
    
    func hideCalendarPicker() {
        self.calendarPickerVisible = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.animate(withDuration: 0.33, animations: { self.calendarPicker.alpha = 0.0} , completion: { (finished: Bool) in self.calendarPicker.isHidden = true})
    }
    
    func refresh() {
        calendarPicker.reloadAllComponents()
        calendarField.text = em.calendar
        eventField.text = em.filter
        fixField.text = em.fix
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = self.tableView.rowHeight
        if (indexPath.section == 0 && indexPath.row == 1) {
            height = self.calendarPickerVisible ? 130.0 : 0.0
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected section \(indexPath.section) in row \(indexPath.row)")
        //Spinner view functionality tied to position in table, will need fixing if table elements are changed.
        if (indexPath.section == 0 && indexPath.row == 0) {
            if (calendarPickerVisible) {
                hideCalendarPicker()
            } else {
                showCalendarPicker()
            }
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberOfCalendars = em.eventFixer.listCalendars().count
        return numberOfCalendars
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let allCalendars = em.eventFixer.listCalendars()
        return allCalendars[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        em.calendar = em.eventFixer.listCalendars()[row]
        self.refresh()
    }
}
