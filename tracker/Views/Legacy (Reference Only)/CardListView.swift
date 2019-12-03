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

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) var mode
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var title = ""

    var body: some View {
        VStack {
            ScrollView {
                ForEach(self.tripCards) { card in
                    HStack {
                        if self.mode?.wrappedValue == .active {
                            Button("DELETE") {
                                self.managedObjectContext.delete(card)
                            }
                            .padding()

                            CardDetailView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                        } else {
//                            NavigationLink(destination: EventInfoView(title: card.title ?? "title place holder", type : card.type ?? "general", dateString: self.dateFormatter.string(from: card.start ?? Date()))) {
//                                CardDetailView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
//                            }
//                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }

            HStack {
                if self.mode?.wrappedValue == .inactive {
                    Button(action: {
                        if self.title != "" {}
                    }) {
                        NavigationLink(destination: AddEventView()) {
                            Text("Add event")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }

                Spacer()
                Button(self.mode?.wrappedValue == .inactive ? "Delete" : "Cancel") {
                    self.mode?.animation().wrappedValue = self.mode?.wrappedValue == .inactive ? .active : .inactive
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardListView()
        }
    }
}
