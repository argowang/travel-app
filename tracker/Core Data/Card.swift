//
//  Card.swift
//  tracker
//
//  Created by bingxin on 11/27/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import Foundation

public class Card: NSManagedObject, Identifiable {
    @NSManaged public var title: String?
    @NSManaged public var start: String?
    @NSManaged public var end: String?
}

extension Card {
    static func allTripCardsFetchRequest() -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = NSFetchRequest<Card>(entityName: "Card")
        request.sortDescriptors = [NSSortDescriptor(key: "end", ascending: false)]
        return request
    }
}
