//
//  Place.swift
//  tracker
//
//  Created by TechLead on 12/10/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreLocation
import Foundation

class Place: NSObject, ObservableObject {
    @Published var name: String
    @Published var coordinate: CLLocationCoordinate2D?

    init(_ inputName: String, _ inputCoordinate: CLLocationCoordinate2D?) {
        name = inputName
        coordinate = inputCoordinate
    }

    init(_ inputName: String) {
        name = inputName
    }

    init(_ place: Place) {
        name = place.name
        coordinate = place.coordinate
    }

    override init() {
        name = ""
        coordinate = nil
    }
}
