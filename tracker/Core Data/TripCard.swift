//
//  TripCard.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/28/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import Foundation

public class TripCard: NSManagedObject, Identifiable {
    @NSManaged public var title: String?
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?

    @NSManaged public var events: NSSet?
}

extension TripCard {
    static func allTripCardsFetchRequest() -> NSFetchRequest<TripCard> {
        let request: NSFetchRequest<TripCard> = NSFetchRequest<TripCard>(entityName: "TripCard")
        request.sortDescriptors = [NSSortDescriptor(key: "start", ascending: false)]
        return request
    }

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventCard)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventCard)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)
}
