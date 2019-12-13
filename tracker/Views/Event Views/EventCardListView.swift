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

struct EventCardListView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    @Environment(\.managedObjectContext) var managedObjectContext
    @State var title = ""
    @State var refreshing = false
    @State var selected: UUID?
    @State var showingSheet = false
    @State var addEventActive = false
    @State var eventType: EventType = .general
    
    @State var trip: TripCard = TripCard()

    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.trip.events, id: \.uuid) { card in
                    ZStack {
                        NavigationLink(destination:
                        AddEventView(selectedDate: card.start ?? Date(), selectedTime: card.start ?? Date(), price: card.price ?? "", type: EventType(rawValue: card.type ?? EventType.general.rawValue), rating: Int(card.rating), transporatation: card.transportation ?? "", card: card as! EventCard, trip: self.$trip, place: Place(card.title ?? "", CLLocationCoordinate2D(latitude: card.latitude, longitude: card.longitude)), origin: Place(card.originTitle ?? "", CLLocationCoordinate2D(latitude: card.originLatitude, longitude: card.originLongitude))), tag: card.uuid!, selection: self.$selected) {
                            Text("Work Around")
                        }.hidden()
                        EventCardView(title: card.title ?? "title place holder", type: EventType(rawValue: card.type ?? EventType.general.rawValue), dateString: self.dateFormatter.string(from: card.start ?? Date()))
                            .onTapGesture {
                                self.selected = card.uuid
                            }
                    }
                    .padding(.bottom, 5)
                    .contextMenu {
                        Button(action: {
                            self.selected = card.uuid
                        }) {
                            HStack {
                                Text("See Detail")
                                Image(systemName: "arrowshape.turn.up.right.circle")
                            }
                        }
                        Button(action: {
                            self.managedObjectContext.delete(card)
                        }) {
                            HStack {
                                Text("Remove")
                                Image(systemName: "trash.circle")
                            }
                        }
                    }
                }
                // temp fix, fetchrequest sometimes will not update, this is apple native bug
                .onReceive(self.didSave) { _ in
                    self.refreshing.toggle()
                }
            }
//            VStack(alignment: .trailing) {
//                Spacer()
//                HStack {
//                    Spacer()
//                    // https://forums.developer.apple.com/thread/124757
//                    NavigationLink(destination: AddEventView(type: eventType, trip: self.$trip), isActive: self.$addEventActive) {
//                        Text("Work Around")
//                    }.hidden()
//
//                    Button(action: {
//                        if self.title != "" {}
//                        self.showingSheet = true
//                    }) {
//                        Image("plus")
//                            .resizable()
//                            .frame(width: 90, height: 90)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .padding()
//                    .actionSheet(isPresented: $showingSheet) {
//                        ActionSheet(title: Text("Select an event type fits for you."), message: Text("Choose general if you are not satisified with all options"), buttons: [
//                            .default(
//                                Text("Food"),
//                                action: {
//                                    self.addEventActive = true
//                                    self.eventType = .food
//                                }
//                            ),
//                            .default(
//                                Text("Transportation"),
//                                action: {
//                                    self.addEventActive = true
//                                    self.eventType = .transportation
//                                }
//                            ),
//                            .default(
//                                Text("General"),
//                                action: {
//                                    self.addEventActive = true
//                                    self.eventType = .general
//                                }
//                            ),
//                            .destructive(Text("Dismiss")),
//                        ])
//                    }
//                }
//            }
        }
    }
}

//struct EventCardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            EventCardListView()
//        }
//    }
//}
