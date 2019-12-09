//
//  EventType.swift
//  tracker
//
//  Created by TechLead on 12/8/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Foundation
import SwiftUI

enum EventType: String {
    case general
    case food
    case transportation

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
