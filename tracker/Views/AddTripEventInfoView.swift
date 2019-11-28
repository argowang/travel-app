//
//  AddTripEventInfoView.swift
//  tracker
//
//  Created by bingxin on 11/27/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
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
            TextField("Name Currrent Visiting Location", text: self.$title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            DatePicker(selection: $start, in: ...Date(), displayedComponents: .date) {
                Text("Select a date")
            }

            Text("Date is \(start, formatter: dateFormatter)")

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

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripEventInfoView()
    }
}
