//
//  EventType.swift
//  tracker
//
//  Created by TechLead on 12/8/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Foundation
import SwiftUI

enum EventType: String, CaseIterable {
    case general
    case food
    case transportation

    static let allValues = [food, transportation, general]

    init(rawValue: String) {
        switch rawValue {
        case "transportation":
            self = .transportation
        case "food":
            self = .food
        default:
            self = .general
        }
    }

    func getImage() -> Image {
        return Image(rawValue)
    }
}
