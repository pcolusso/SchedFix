//
//  EventFixer.swift
//  SchedFixTest
//
//  Created by Paul Colusso on 7/11/16.
//  Copyright © 2016 Paul Colusso. All rights reserved.
//

import EventKit

class EventFix {
    let targetCalendar, filter, fix: String
    let eventStore: EKEventStore = EKEventStore()
    
    var events: [EKEvent] = []
    
    //Initialises settings for operation
    init(forCalendarWithString: String, eventsMatching: String, replaceWith: String) {
        targetCalendar = forCalendarWithString
        filter = eventsMatching
        fix = replaceWith
        
        refreshEvents()
    }
    
    //Called eventStore becomes invalid. For example, was init'd without proper authorisation.
    func refreshStore() {
        eventStore.reset()
        refreshEvents()
    }
    
    //Called when the internal events[] cache is out of date.
    func refreshEvents() {
        events = fetchEvents()
    }
    
    //Retrieves events from the event store that match the specified filters.
    func fetchEvents() -> [EKEvent] {
        let allCalendars = eventStore.calendars(for: .event)
        
        for calendar in allCalendars {
            if calendar.title == targetCalendar {
                let oneMonthAgo = Date(timeIntervalSinceNow: -30 * 24 * 3600)
                let oneMonthForward = Date(timeIntervalSinceNow: +30 * 24 * 3600)
                let timePred = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthForward, calendars: [calendar])
                
                let events = eventStore.events(matching: timePred)
                let filteredEvents = events.filter { $0.title.range(of: filter) != nil }
                
                //print("Found \(filteredEvents.count) events.")
                
                return filteredEvents
            }
        }
        
        return []
    }
    
    //Checks to see if authorised and reduces to a bool.
    func isAuthorised() -> Bool {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        return status == .authorized
    }
    
    //Actually required to have app appear in privacy settings. Takes a closure for completion.
    func requestAuthorisation(completion: @escaping (Bool, Error?) -> Void) {
        //Tidy, perhaps move closure to param
        eventStore.requestAccess(to: .event, completion: completion)
        eventStore.reset()
        refreshEvents()
        
    }
    
    //Applies fix to matched events.
    func fixEvents() {
        for e in events {
            e.title = fix
            try! eventStore.save(e, span: .thisEvent, commit: false)
        }
        
        try! eventStore.commit()
        refreshEvents()
    }
    
    //Returns events in a string array
    func listEvents() -> [String] {
        return events.map{$0.title}
    }
    
    func listCalendars() -> [String] {
        let allCalendars = eventStore.calendars(for: .event)
        let list = allCalendars.map { $0.title }
        
        return list
    }
}

enum EventFixError: Error {
    case notAuthorised
}
