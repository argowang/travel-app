//
//  EventCard.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import CoreLocation
import Foundation

public class EventCard: NSManagedObject, Identifiable {
    @NSManaged public var title: String
    @NSManaged public var start: Date
    @NSManaged public var type: String
    @NSManaged public var uuid: UUID
    @NSManaged public var rating: Int16
    @NSManaged public var placeName: String
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var originName: String
    @NSManaged public var originLongitude: Double
    @NSManaged public var originLatitude: Double
    @NSManaged public var price: String
    @NSManaged public var transportation: String
    @NSManaged public var eventDescription: String

    @NSManaged public var trip: TripCard
}

extension EventCard {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    public var wrappedRating: Int {
        Int(rating)
    }

    public var formattedStartString: String {
        dateFormatter.string(from: start)
    }

    static func allEventCardsFetchRequest() -> NSFetchRequest<EventCard> {
        let request: NSFetchRequest<EventCard> = NSFetchRequest<EventCard>(entityName: "EventCard")
        request.sortDescriptors = [NSSortDescriptor(key: "start", ascending: false)]
        return request
    }

    func location() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func originLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude)
    }
}
