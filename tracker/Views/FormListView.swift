//
//  FormListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import MapKit
import SwiftUI

struct FormListView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    locationRow()
                }
                .navigationBarTitle("Your Trip")
            }
        }
    }
}

struct locationRow: View {
    @State private var newLocation = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    var body: some View {
        HStack {
            Text("Location:")
            NavigationLink(destination: SetCurrentLocationView(newLocation: self.$newLocation, selectedCoordinate: self.$selectedCoordinate).environmentObject(PlaceFinder())) {
                Text("\(self.newLocation)")
            }
            .padding()
        }
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView()
    }
}
