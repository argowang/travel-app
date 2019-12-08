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
    @State var card: EventCard
    @State private var goEdit: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            // https://forums.developer.apple.com/thread/124757
            NavigationLink(destination: AddEventView(title: card.title ?? "", defaultTitle: "", selectedDate: card.start ?? Date(), selectedTime: Date(), type: card.type ?? "", rating: 5, card: card), isActive: self.$goEdit) {
                Text("Work Around")
            }.hidden()

            HStack {
                Image(EventDetailView.getImage(type: card.type ?? "general"))
                    .resizable()
                    .frame(width: 60, height: 60)

                Text("Event Type : \(card.type ?? "")")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Image("location")
                    .resizable()
                    .frame(width: 60, height: 60)

                Text("Location : \(card.title ?? "")")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Image("calendar")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("Date is \(self.dateFormatter.string(from: card.start ?? Date()))")
            }

            Spacer()
        }
        .navigationBarItems(trailing: Button(action: { self.goEdit = true }, label: { Text("Edit") }))
    }
}

struct ViewTripEventInfoView_Previews: PreviewProvider {
    static var title = ""
    static var dateString = ""
    static var date = Date()
    static var type = ""
    static var card = EventCard()
    static var previews: some View {
        EventInfoView(title: title, type: type, start: date, card: card)
    }
}
