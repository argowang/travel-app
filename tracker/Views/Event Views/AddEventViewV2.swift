//
//  AddEventViewV2.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct AddEventViewV2: View {
    @ObservedObject var draftEvent: UserEvent

    @EnvironmentObject var manager: LocationManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    let animation = Animation.easeInOut(duration: 1.0)
    @State var formPageIndex: Int = 0
    @State var string: String = ""
    var body: some View {
        VStack {
            SwipeView()
            if draftEvent.type == .transportation {
                transportationLocationRow(origin: draftEvent.origin, destination: draftEvent.place)
            } else {
                locationRow(place: draftEvent.place)
            }
            VStack {
                Form {
                    Section(header: HStack {
                        Text("Title:")
                        Spacer()
                        Button(action: {
                            if self.draftEvent.type == .transportation {
                                self.draftEvent.title = "From \(self.draftEvent.origin.name) to \(self.draftEvent.place.name)"
                            } else {
                                self.draftEvent.title = self.draftEvent.place.name
                            }
                        }) {
                            Text("Sync with location")
                        }
                    }) {
                        HStack {
                            TextFieldWithDelete("Enter event title", text: $draftEvent.title)
                        }
                    }

                    Section {
                        datePicker(selectedDate: $draftEvent.dateForDate)
                        timePicker(selectedTime: $draftEvent.dateForTime)
                    }
                    Section(header: Text("💰 Price:")) {
                        HStack {
                            TextFieldWithDelete("Enter price here", text: $draftEvent.price)
                                .foregroundColor(.secondary)
                        }
                    }
                    Section(header: Text("👍 Rating:")) {
                        HStack {
                            StarRatingView(rating: $draftEvent.rating)
                        }
                    }
                    if draftEvent.type == .transportation {
                        Section(header: Text("Transportation")) {
                            VStack(alignment: .leading) {
                                transporatationMethodsSelectionRow(transportationMethod: $draftEvent.transportation)
                            }
                        }
                    }

                    Section(header: Text("Description")) {
                        HStack {
                            TextFieldWithDelete("Enter your description here", text: $draftEvent.eventDescription)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
        .navigationBarTitle(Text("\(draftEvent.type.rawValue)"))
        .navigationBarItems(trailing: Button(action: {
            var cardToSave: EventCard!
            if self.draftEvent.event != nil {
                cardToSave = self.draftEvent.event
            } else {
                cardToSave = EventCard(context: self.managedObjectContext)
                cardToSave.uuid = UUID()
                self.draftEvent.parentTrip.addToEvents(cardToSave)
            }
            cardToSave.placeName = self.draftEvent.place.name
            cardToSave.latitude = self.draftEvent.place.coordinate?.latitude ?? 0
            cardToSave.longitude = self.draftEvent.place.coordinate?.longitude ?? 0

            if self.draftEvent.type == .transportation {
                cardToSave.originName = self.draftEvent.origin.name
                cardToSave.originLatitude = self.draftEvent.origin.coordinate?.latitude ?? 0
                cardToSave.originLongitude = self.draftEvent.origin.coordinate?.longitude ?? 0
                cardToSave.transportation = self.draftEvent.transportation
            }

            cardToSave.title = self.draftEvent.title

            cardToSave.start = self.draftEvent.calculatedDate
            cardToSave.type = self.draftEvent.type.rawValue
            cardToSave.rating = Int16(self.draftEvent.rating)
            cardToSave.price = self.draftEvent.price
            cardToSave.eventDescription = self.draftEvent.eventDescription

            do {
                try self.managedObjectContext.save()
                self.mode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
        }, label: { Text("Save") }).disabled(isSaveAllowed(draftEvent)))
    }

    // Add custom validation logic here
    func isSaveAllowed(_: UserEvent) -> Bool {
        return draftEvent.title == ""
    }
}
