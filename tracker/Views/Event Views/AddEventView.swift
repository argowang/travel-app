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

struct AddEventView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @State var title = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var start = Date()
    @State var type = "General"
    @ObservedObject var manager = LocationManager()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            eventTypeRow(type: $type)

            DatePicker(selection: $start, in: ...Date(), displayedComponents: .date) {
                Text("Select a date")
            }
            .padding()

            Text("Date is \(start, formatter: dateFormatter)")
                .padding()

            locationRows(newLocation: self.$title, autoPopulated: self.$manager.lastCity)
                .padding()

            Button(action: {
                let card = EventCard(context: self.managedObjectContext)

                if self.title != "" {
                    card.title = self.title
                } else {
                    card.title = self.manager.lastCity
                }

                card.start = self.start
                card.type = self.type

                do {
                    try self.managedObjectContext.save()
                    self.mode.wrappedValue.dismiss()
                } catch {
                    print(error)
                }
            }) {
                Text("Add event")
            }
            .padding()
            Spacer()
        }.onAppear {
            self.manager.updateOnce()
        }
    }
}

struct locationRows: View {
    @Binding var newLocation: String
    @Binding var autoPopulated: String?
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        List {
            HStack {
                Text("Location:")
                NavigationLink(destination: SetCurrentLocationView(newLocation: self.$newLocation, selectedCoordinate: self.$selectedCoordinate).environmentObject(PlaceFinder())) {
                    if self.newLocation == "" {
                        Text("\(self.autoPopulated ?? "")")
                    } else {
                        Text("\(self.newLocation)")
                    }
                }
                .padding()
            }
        }
    }
}

struct eventTypeRow: View {
    @Binding var type: String

    var body: some View {
        VStack {
            Text("Event Type: \(type)")
                .padding()
            HStack {
                Button(action: { self.type = "General"
                }) {
                    Text("General")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(20)

                Button(action: { self.type = "Transportation"
                }) {
                    Text("Transportation")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.purple)
                .cornerRadius(20)

                Button(action: { self.type = "Food"
                }) {
                    Text("Food")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.green)
                .cornerRadius(20)
            }
        }
    }
}

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}
