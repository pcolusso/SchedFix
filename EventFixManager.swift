//
//  EventFixManager.swift
//  SchedFix
//
//  Created by Paul Colusso on 9/11/16.
//  Copyright © 2016 Paul Colusso. All rights reserved.
//

import Foundation

struct EventFixKeys {
    static let calendar = KeyDefault(key: "cal", defaultValue: "Work")
    static let filter = KeyDefault(key: "filter", defaultValue: "Boring Event Name")
    static let fix = KeyDefault(key: "sub", defaultValue: "New Title")
}

struct KeyDefault {
    var key: String
    var defaultValue: String
}

class EventFixManager {
    //Singleton definition
    static let sharedInstance = EventFixManager()
    let defaults = UserDefaults.standard
    
    var eventFixer: EventFix
    
    var calendar: String {
        get {
            return fetchValue(forKey: EventFixKeys.calendar)
        }
        set(newValue) {
            setValue(forKey: EventFixKeys.calendar, value: newValue)
        }
    }
    
    var filter: String {
        get {
            return fetchValue(forKey: EventFixKeys.filter)
        }
        set(newValue) {
            setValue(forKey: EventFixKeys.filter, value: newValue)
        }
    }
    
    var fix: String {
        get {
            return fetchValue(forKey: EventFixKeys.fix)
        }
        set(newValue) {
            setValue(forKey: EventFixKeys.fix, value: newValue)
        }
    }
    
    private init() {
        let c = defaults.string(forKey: EventFixKeys.calendar.key) ?? EventFixKeys.calendar.defaultValue
        let f = defaults.string(forKey: EventFixKeys.filter.key) ?? EventFixKeys.filter.defaultValue
        let s = defaults.string(forKey: EventFixKeys.fix.key) ?? EventFixKeys.fix.defaultValue
        
        eventFixer = EventFix(forCalendarWithString: c, eventsMatching: f, replaceWith: s)
    }
    
    private func fetchValue(forKey: KeyDefault) -> String {
        if let value = defaults.string(forKey: forKey.key) {
            return value //Only exit is to read from defaults
        } else {
            defaults.set(forKey.defaultValue, forKey: forKey.key)
            return fetchValue(forKey: forKey)
        }
    }
    
    private func setValue(forKey: KeyDefault, value: String){
        defaults.set(value, forKey: forKey.key)
        rebuildEventFix()
    }
    
    private func rebuildEventFix() {
        eventFixer = EventFix(forCalendarWithString: calendar, eventsMatching: filter, replaceWith: fix)
    }
    
    func reset() {
        calendar = EventFixKeys.calendar.defaultValue
        filter = EventFixKeys.filter.defaultValue
        fix = EventFixKeys.fix.defaultValue
        
        rebuildEventFix()
    }
}
