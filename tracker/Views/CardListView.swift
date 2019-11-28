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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Card.allTripCardsFetchRequest()) var tripCards: FetchedResults<Card>
    @State var title = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(self.tripCards) { card in
                            CardView(title: card.title ?? "title place holder", dateString: card.start ?? "date string place holder")
                        } 
                    }
                }
                Button(action: {
                    if self.title != "" {
                    }
                }) {
                    NavigationLink(destination: AddTripEventInfoView()) {
                        Text("Add event")
                    }
                }
            }
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
