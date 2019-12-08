//
//  ViewTripEventInfo.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/28/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import Foundation
import SwiftUI

struct EventInfoView: View {
    var title: String
    var type: String
    var start: Date

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) var mode

    var body: some View {
        VStack(alignment: .leading) {
            if self.mode?.wrappedValue == .inactive {
                HStack {
                    Image(EventDetailView.getImage(type: type))
                        .resizable()
                        .frame(width: 60, height: 60)

                    Text("Event Type : \(type)")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                HStack {
                    Image("location")
                        .resizable()
                        .frame(width: 60, height: 60)

                    Text("Location : \(title)")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                HStack {
                    Image("calendar")
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text("Date is \(self.dateFormatter.string(from: self.start))")
                }

                Spacer()
            } else {
                AddEventView(title: self.title, defaultTitle: "", selectedDate: self.start, selectedTime: Date(), type: self.type, rating: 5)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            self.mode?.animation().wrappedValue = self.mode?.wrappedValue == .inactive ? .active : .inactive
            }, label: { Text(self.mode?.wrappedValue == .inactive ? "Edit" : "Save")
        }))
    }
}

struct ViewTripEventInfoView_Previews: PreviewProvider {
    static var title = ""
    static var dateString = ""
    static var date = Date()
    static var type = ""
    static var previews: some View {
        EventInfoView(title: title, type: type, start: date)
    }
}
