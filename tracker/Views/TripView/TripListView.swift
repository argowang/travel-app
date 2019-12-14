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
    @Environment(\.editMode) var mode
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var title = ""
    @State var showingDetail = false

    var body: some View {
        VStack {
            ScrollView {
                ForEach(self.tripCards) { card in
                    if self.mode?.wrappedValue == .active {
                        Button("DELETE") {
                            self.managedObjectContext.delete(card)
                        }
                        .padding()

                        TripCardView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                    } else {
                        NavigationLink(destination: LazyView(EventCardListView(trip: card))) {
                            TripCardView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            VStack {
                if self.mode?.wrappedValue == .inactive {
                    Button(action: {
                        self.showingDetail.toggle()
                    }) {
                        Text("Add Trip")
                    }
                    .sheet(isPresented: $showingDetail, onDismiss: {
                        // we should decide on dismiss behavior here
                        print("on dismiss")
                    }) {
                        AddTripView().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
            }
        }
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
