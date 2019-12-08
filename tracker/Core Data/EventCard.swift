//
//  EventCard.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import Foundation

public class EventCard: NSManagedObject, Identifiable {
    @NSManaged public var title: String?
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var type: String?
    @NSManaged public var uuid: UUID?
}

extension EventCard {
    static func allEventCardsFetchRequest() -> NSFetchRequest<EventCard> {
        let request: NSFetchRequest<EventCard> = NSFetchRequest<EventCard>(entityName: "EventCard")
        request.sortDescriptors = [NSSortDescriptor(key: "start", ascending: false)]
        return request
    }
}
