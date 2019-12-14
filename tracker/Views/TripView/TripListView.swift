//
//  TripListView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import SwiftUI

struct TripListView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var showingDetail = false
    @State var selected: UUID?

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.tripCards) { card in
                    ZStack {
                        NavigationLink(destination: LazyView(EventCardListView(trip: card)), tag: card.uuid, selection: self.$selected) {
                            Text("Work Around")
                        }.hidden()

                        TripCardView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                            .onTapGesture {
                                self.selected = card.uuid
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(action: {
                            self.managedObjectContext.delete(card)
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }) {
                            HStack {
                                Text("Remove")
                                Image(systemName: "trash.circle")
                            }
                        }
                    }
                }
            }
            FloatingAddButtonView(destinationView: AddTripView().environment(\.managedObjectContext, self.managedObjectContext))
        }
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
