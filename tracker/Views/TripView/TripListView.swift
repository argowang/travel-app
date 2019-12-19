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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var showingDetail = false
    @State var selected: UUID?

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.tripCards) { card in
                    NavigationLink(destination: LazyView(EventCardListView(trip: card)), tag: card.uuid, selection: self.$selected, label: { EmptyView() })

                    TripCardView(tripCard: card)
                        .onTapGesture {
                            self.selected = card.uuid
                        }
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
