//
//  AddTripEventInfoView.swift
//  tracker
//
//  Created by bingxin on 11/27/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import MapKit
import SwiftUI

struct AddTripEventInfoView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @State var title = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var start = Date()

    var body: some View {
        VStack {
            DatePicker(selection: $start, in: ...Date(), displayedComponents: .date) {
                Text("Select a date")
            }
            .padding()

            Text("Date is \(start, formatter: dateFormatter)")
                .padding()

            locationRows(newLocation: self.$title)
                .padding()

            Button(action: {
                if self.title != "" {
                    let card = TripCard(context: self.managedObjectContext)

                    card.title = self.title
                    card.start = self.start

                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }

                    self.title = ""
                }
            }) {
                Text("Add event")
            }
            .padding()
            Spacer()
        }
    }
}

struct locationRows: View {
    @Binding var newLocation: String
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    var body: some View {
        List {
            HStack {
                Text("Location:")
                NavigationLink(destination: SetCurrentLocationView(newLocation: self.$newLocation, selectedCoordinate: self.$selectedCoordinate).environmentObject(PlaceFinder())) {
                    Text("\(self.newLocation)")
                }
                .padding()
            }
        }
    }
}

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripEventInfoView()
    }
}
