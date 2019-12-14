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
    @FetchRequest(fetchRequest: EventCard.allEventCardsFetchRequest()) var eventCards: FetchedResults<EventCard>

    @State var title = ""
    @State private var refreshing = false
    @State var selected: UUID?
    @State private var showingSheet = false
    @State private var addEventActive = false
    @State var eventType: EventType = .general

    let tripUuid: UUID

    init(tripUuid: UUID) {
        self.tripUuid = tripUuid
        print(tripUuid)
        _eventCards = FetchRequest<EventCard>(fetchRequest: EventCard.getSpecificTrip(tripUuid: tripUuid))
    }

    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.eventCards, id: \.uuid) { card in
                    ZStack {
                        NavigationLink(destination:
                            AddEventView(tripUuid: self.tripUuid, card: card, draftEvent: UserEvent(card)), tag: card.uuid, selection: self.$selected) {
                            Text("Work Around")
                        }.hidden()

                        EventCardView(title: card.title, type: EventType(rawValue: card.type), dateString: self.dateFormatter.string(from: card.start))
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
            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    // https://forums.developer.apple.com/thread/124757
                    NavigationLink(destination: AddEventView(tripUuid: self.tripUuid, draftEvent: UserEvent()), isActive: self.$addEventActive) {
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
            EventCardListView(tripUuid: UUID())
        }
    }
}
