//
//  ContentView.swift
//  tracker
//
//  Created by TechLead on 11/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import MapKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TripListView()
                .navigationBarTitle("Your Trip")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
