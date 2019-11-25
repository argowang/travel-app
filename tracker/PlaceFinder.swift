//
//  PlaceFinder.swift
//  tracker
//
//  Created by TechLead on 11/23/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import MapKit
import SwiftUI

class PlaceFinder: NSObject, ObservableObject {
    @Published var results: [String]

    private var searcher: MKLocalSearchCompleter

    var searchString: String = "" {
        didSet {
            if searchString == "" {
                results = []
            } else {
                search(searchString)
            }
        }
    }

    override init() {
        results = []
        searcher = MKLocalSearchCompleter()
        super.init()
        searcher.resultTypes = .query
        searcher.delegate = self
    }

    func search(_ text: String) {
        searcher.queryFragment = text
    }
}

extension PlaceFinder: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results.map { $0.title }
    }
}
