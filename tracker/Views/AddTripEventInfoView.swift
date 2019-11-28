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
    @State var title = ""
    @State var start = ""
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        VStack {
            TextField("Name Currrent Visiting Location", text: self.$title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Enter Start Date", text: self.$start)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if self.title != "" {
                    let card = TripCard(context: self.managedObjectContext)

                    card.title = self.title
//                    card.start = self.start

                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }

                    self.title = ""
                    self.start = ""
                }
            }) {
                Text("Add event")
            }
            Spacer()
        }
    }
}

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripEventInfoView()
    }
}
