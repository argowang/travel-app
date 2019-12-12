//
//  TripListView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows) { row in
                HStack {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct subview: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    let row: Int
    let col: Int
    let index: Int
    var tripCards: FetchedResults<TripCard>

    var body: some View {
        TripCardView(title: self.tripCards[index].title ?? "title place holder", dateString: self.dateFormatter.string(from: self.tripCards[index].start ?? Date()))
    }

    init(row: Int, col: Int, tripCards: FetchedResults<TripCard>) {
        self.row = row
        self.col = col
        self.tripCards = tripCards
        index = row * col + col
    }
}

struct TripListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) var mode
    @FetchRequest(fetchRequest: TripCard.allTripCardsFetchRequest()) var tripCards: FetchedResults<TripCard>
    @State var title = ""
    @State private var left = true
    @State private var e = 1
    
    var body: some View {
            VStack {
                ScrollView {
                    ForEach(0..<self.tripCards.count) { index in
                        Text(String(describing: index)).tag(index)
                    }
                    GridStack(rows: tripCards.count / 2 + tripCards.count % 2, columns: 2) { row, col in
                        subview(row: row, col: col, tripCards: self.tripCards)
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
