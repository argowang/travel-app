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
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var trip: TripCard
    @State var selected: UUID?
    @State var addEventActive = false
    @State var eventType: EventType = .general
    @State var refreshing = false

    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        ZStack {
            RefreshView(refresh: refreshing)
            ScrollView {
                ForEach(self.trip.eventArray, id: \.uuid) { card in
                    VStack {
                        NavigationLink(destination:
                            AddEventView(draftEvent: UserEvent(card, self.trip)), tag: card.uuid, selection: self.$selected, label: { EmptyView() })

                        EventCardView(title: card.title, type: EventType(rawValue: card.type), dateString: card.formattedStartString)
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
            }.onReceive(self.didSave) { _ in
                self.refreshing.toggle()
            }

            FloatingMenuView()
            // https://forums.developer.apple.com/thread/124757

            NavigationLink(destination: AddEventView(draftEvent: UserEvent(self.eventType, trip, self.manager)), isActive: self.$addEventActive, label: { EmptyView() })
        }
    }
}
