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
    @State var date = ""
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        VStack {
            TextField("Name Currrent Visiting Location", text: self.$title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Name A Data", text: self.$date)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if self.title != "" {
                    let card = Card(context: self.managedObjectContext)

                    card.title = self.title
                    card.start = self.date

                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }

                    self.title = ""
                    self.date = ""
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
