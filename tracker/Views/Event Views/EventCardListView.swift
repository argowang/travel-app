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
    @ObservedObject var trip: TripCard
    @State var refreshing = false
    @State var selected: UUID?
    @State var addEventActive = false
    @State var eventType: EventType = .general
    @State var showingModal = false

    var didChange = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    private func displayPopup() {
        showingModal = true
    }

    var body: some View {
        ZStack {
            RefreshView(refresh: refreshing)
            ScrollView {
                ForEach(self.trip.eventArray, id: \.uuid) { card in
                    ZStack {
                        NavigationLink(destination:
                            AddEventViewV2(draftEvent: UserEvent(card, self.trip)), tag: card.uuid, selection: self.$selected) {
                            Text("Work Around")
                        }.hidden()

                        EventCardView(title: card.title, type: EventType(rawValue: card.type), dateString: self.dateFormatter.string(from: card.start))
                            .onTapGesture {
                                self.selected = card.uuid
                            }
                            .background(RefreshView(refresh: self.refreshing))
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
                // temp fix, fetchrequest sometimes will not update, this is apple native bug
                .onReceive(self.didChange) { _ in
                    self.refreshing.toggle()
                }
            }

            FloatingAddButtonView<EmptyView>(extraAction: displayPopup)
            // https://forums.developer.apple.com/thread/124757
            NavigationLink(destination: AddEventViewV2(draftEvent: UserEvent(self.eventType, trip, self.manager)), isActive: self.$addEventActive) {
                Text("Work Around")
            }.hidden()

            AddEventSelectTypeView(display: $showingModal, navigateToAddEventView: $addEventActive, eventType: $eventType)
        }
    }
}
