//
//  UserEvent.swift
//  tracker
//
//  Created by TechLead on 12/12/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import CoreLocation
import Foundation

class UserEvent: NSObject, ObservableObject {
    @Published var title: String
    @Published var dateForDate: Date
    @Published var dateForTime: Date
    @Published var price: String
    @Published var type: EventType
    @Published var rating: Int
    @Published var transportation: String
    @Published var eventDescription: String
    @Published var place: Place
    @Published var origin: Place
    @Published var parentTrip: TripCard
    @Published var event: EventCard?

    public var calculatedDate: Date {
        let dateInt = (Int(dateForDate.timeIntervalSince1970) / (3600 * 24)) * (3600 * 24)
        let timeInt = Int(dateForTime.timeIntervalSince1970) % (3600 * 24)

        return Date(timeIntervalSince1970: Double(dateInt + timeInt))
    }

    init(_ eventType: EventType, _ trip: TripCard, _ manager: LocationManager) {
        title = ""
        let currDate = Date()
        dateForDate = currDate
        dateForTime = currDate
        price = ""
        type = eventType
        rating = 0
        transportation = ""
        eventDescription = ""
        place = Place()
        origin = Place()
        parentTrip = trip
        super.init()

        manager.continueUpdating()

        let georeader = CLGeocoder()
        if let lastLocation = manager.lastLocation {
            georeader.reverseGeocodeLocation(lastLocation) { places, err in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                self.place.name = places?.first?.locality ?? ""
                self.place.coordinate = lastLocation.coordinate
            }

            manager.stopUpdating()
        }
    }

    init(_ card: EventCard, _ trip: TripCard) {
        title = card.title
        dateForDate = card.start
        dateForTime = card.start
        price = card.price
        type = EventType(rawValue: card.type)
        rating = Int(card.rating)
        transportation = card.transportation
        eventDescription = card.eventDescription
        if EventType(rawValue: card.type) == .transportation {
            origin = Place(card.originName, CLLocationCoordinate2D(latitude: card.originLatitude, longitude: card.originLongitude))
        } else {
            origin = Place()
        }
        place = Place(card.placeName, CLLocationCoordinate2D(latitude: card.latitude, longitude: card.longitude))
        parentTrip = trip
        event = card
    }
}
