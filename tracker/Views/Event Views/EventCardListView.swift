//
//  EventListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import CoreData
import CoreLocation
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
    let row: Int
    let col: Int
    let index: Int
    var eventCards: FetchedResults<EventCard>

//    lazy var index:Int = {
//        return self.row * self.col + self.col
//    }()

    var body: some View {
        EventCardView(title: self.eventCards[index].title ?? "title place holder", type: EventType(rawValue: self.eventCards[index].type ?? EventType.general.rawValue), dateString: "")
//        .onTapGesture {
//            self.selected = self.eventCards[index].uuid
//        }
    }

    init(row: Int, col: Int, eventCards: FetchedResults<EventCard>) {
        self.row = row
        self.col = col
        self.eventCards = eventCards
        index = row * col + col
    }
}

struct EventCardListView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: EventCard.allEventCardsFetchRequest()) var eventCards: FetchedResults<EventCard>

    @State var title = ""
    @State private var refreshing = false
    @State var selected: UUID?
    @State private var showingSheet = false
    @State private var addEventActive = false
    @State var eventType: EventType = .general
    @State private var left = true
    @State private var e = 1

    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        ZStack {
            ScrollView {
                GridStack(rows: eventCards.count / 2 + eventCards.count % 2, columns: 2) { row, col in
                    //    ForEach(self.eventCards, id: \.uuid) { card in

//                            NavigationLink(destination:
//                                AddEventView(selectedDate: card.start ?? Date(), selectedTime: card.start ?? Date(), price: card.price ?? "", type: EventType(rawValue: card.type ?? EventType.general.rawValue), rating: Int(card.rating), transporatation: card.transportation ?? "", card: card as! EventCard, place: Place(card.title ?? "", CLLocationCoordinate2D(latitude: card.latitude, longitude: card.longitude)), origin: Place(card.originTitle ?? "", CLLocationCoordinate2D(latitude: card.originLatitude, longitude: card.originLongitude))), tag: card.uuid!, selection: self.$selected) {
//                                Text("Work Around")
//                            }.hidden()
                    subview(row: row, col: col, eventCards: self.eventCards)
//                    EventCardView(title: self.eventCards[row + col].title ?? "title place holder", type: EventType(rawValue: self.eventCards[row * col + col].type ?? EventType.general.rawValue), dateString: self.dateFormatter.string(from: self.eventCards[row + col].start ?? Date()))
//                                .onTapGesture {
//                                    self.selected = self.eventCards[row + col].uuid
//                                }
                }
            }
            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    // https://forums.developer.apple.com/thread/124757
                    NavigationLink(destination: AddEventView(type: eventType), isActive: self.$addEventActive) {
                        Text("Work Around")
                    }.hidden()

                    Button(action: {
                        if self.title != "" {}
                        self.showingSheet = true
                    }) {
                        Image("plus")
                            .resizable()
                            .frame(width: 90, height: 90)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .actionSheet(isPresented: $showingSheet) {
                        ActionSheet(title: Text("Select an event type fits for you."), message: Text("Choose general if you are not satisified with all options"), buttons: [
                            .default(
                                Text("Food"),
                                action: {
                                    self.addEventActive = true
                                    self.eventType = .food
                                }
                            ),
                            .default(
                                Text("Transportation"),
                                action: {
                                    self.addEventActive = true
                                    self.eventType = .transportation
                                }
                            ),
                            .default(
                                Text("General"),
                                action: {
                                    self.addEventActive = true
                                    self.eventType = .general
                                }
                            ),
                            .destructive(Text("Dismiss")),
                        ])
                    }
                }
            }
        }
    }
}

struct EventCardListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EventCardListView()
        }
    }
}
