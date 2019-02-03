//
//  Event.swift
//  CallManager
//
//  Created by James Thomson on 23/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import Foundation

class Event {
    
    var brand = Brand()
    var eventDate: Date
    var city: String
    var eventManagerName: String
    var todolist = [TodoItem]()
    var EID: String
    
    init(eventid: String, eventBrand: Brand, dateofEvent: Date, eventCity: String, emName: String) {
        EID = eventid
        brand = eventBrand
        eventDate = dateofEvent
        city = eventCity
        eventManagerName = emName
    }
}
