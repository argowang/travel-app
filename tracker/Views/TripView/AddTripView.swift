//
//  AddTripView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import SwiftUI

struct AddTripView: View {
    @State var title = ""
    @State var defaultTitle = "hhhhhh"
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var selectedDate = Date()
    @State var selectedTime = Date()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            datePicker(selectedDate: self.$selectedDate)
                .padding()

            timePicker(selectedTime: self.$selectedTime)
                .padding()

            Button(action: {
                let card = TripCard(context: self.managedObjectContext)

                if self.title != "" {
                    card.title = self.title
                } else {
                    card.title = self.defaultTitle
                }

                card.start = self.selectedDate
                card.uuid = UUID()

                print(card.uuid)

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
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
