//
//  TripListView.swift
//  tracker
//
//  Created by 郭怡明 on 12/2/19.
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
    
    var body: some View {
            VStack {
                Text("SwiftUI")
                Text("rocks")
                ScrollView {
                    ForEach(self.tripCards) { card in
                        HStack {
                            if self.mode?.wrappedValue == .active {
                                Button("DELETE") {
                                    self.managedObjectContext.delete(card)
                                }
                                .padding()

                                TripCardview(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                            } else {
                                NavigationLink(destination: TripInfoView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))) {
                                    TripCardview(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                VStack {
                    if self.mode?.wrappedValue == .inactive {
                        Button(action: {
                            if self.title != "" {}
                        }) {
                            NavigationLink(destination: AddTripView()) {
                                Text("Add event")
                            }
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
        VStack {
            TripListView()
        }
    }
}
