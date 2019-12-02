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
    @Published var results: [MKLocalSearchCompletion]

    private var searcher: MKLocalSearchCompleter
    var searchTask: DispatchWorkItem?

    var searchString: String = "" {
        didSet {
            if searchString == "" {
                self.searchTask?.cancel()
                results = []
            } else {
                self.searchTask?.cancel()
                let task = DispatchWorkItem {
                    self.search(self.searchString)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
                self.searchTask = task
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
        results = completer.results
    }
}
