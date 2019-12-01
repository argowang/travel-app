//
//  CardListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import SwiftUI

struct CardListView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    @Environment(\.editMode) var mode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var title = ""

    var body: some View {
        VStack {
            ScrollView {
                ForEach(self.tripCards) { card in
                    if self.mode?.wrappedValue == .inactive {
                        DisplayEventCardView(card: card, dateFormatter: self.dateFormatter)
                    } else {
                        DeleteEventCardView(card: card, dateFormatter: self.dateFormatter)
                    }
                }
            }

            HStack {
                AddEventButtonView()
                Spacer()
                DeleteEventButtonView()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
        }
    }
}

struct DisplayEventCardView: View {
    @State var card: TripCard
    @State var dateFormatter: DateFormatter

    var body: some View {
        NavigationLink(destination: ViewTripEventInfoView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))) {
            CardView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DeleteEventCardView: View {
    @State var card: TripCard
    @State var dateFormatter: DateFormatter

    var body: some View {
        HStack {
            Button("DELETE") {
                // todo add delete function
//                self.mode?.animation().wrappedValue = .active
            }
            .padding()
            CardView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
        }
    }
}

struct AddEventButtonView: View {
    @State var title = ""

    var body: some View {
        Button(action: {
            if self.title != "" {}
        }) {
            NavigationLink(destination: AddTripEventInfoView()) {
                Text("Add event")
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
    }
}

struct DeleteEventButtonView: View {
    @State var title = ""
    @Environment(\.editMode) var mode

    var body: some View {
        Button(self.mode?.wrappedValue == .inactive ? "Delete" : "Cancel") {
            self.mode?.animation().wrappedValue = self.mode?.wrappedValue == .inactive ? .active : .inactive
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardListView()
        }
    }
}
