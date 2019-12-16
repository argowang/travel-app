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
            SwipeView(draftEvent: self.draftEvent)
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
        }, label: { Text("Save") }) // .disabled(isSaveAllowed(draftEvent))
        )
    }

    // Add custom validation logic here
    func isSaveAllowed(_: UserEvent) -> Bool {
        return draftEvent.title == ""
    }
}
