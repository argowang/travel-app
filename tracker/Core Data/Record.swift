//
//  Record.swift
//  tracker
//
//  Created by TechLead on 11/16/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import Foundation

public class Record: NSManagedObject, Identifiable {
    @NSManaged public var location: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var date: Date?
}

extension Record {
    static func allRecordsFetchRequest() -> NSFetchRequest<Record> {
        let request: NSFetchRequest<Record> = NSFetchRequest<Record>(entityName: "Record")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return request
    }
}
