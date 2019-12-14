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

    init(_ trip: TripCard, _ eventType: EventType) {
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
        place = Place(card.title, CLLocationCoordinate2D(latitude: card.latitude, longitude: card.longitude))
        origin = Place()
        parentTrip = trip
    }
}
