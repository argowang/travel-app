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
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var title = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(self.tripCards) { card in
                        NavigationLink(destination: ViewTripEventInfoView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))) {
                            CardView(title: card.title ?? "title place holder", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                Button(action: {
                    if self.title != "" {}
                }) {
                    NavigationLink(destination: AddTripEventInfoView()) {
                        Text("Add event")
                    }
                }
            }
        }
        .padding()
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
