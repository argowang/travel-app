//
//  EventListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import CoreData
import SwiftUI
struct EventCardListView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) var mode
    @FetchRequest(fetchRequest: EventCard.allEventCardsFetchRequest()) var eventCards: FetchedResults<EventCard>
    @State var title = ""
    @State private var refreshing = false
    @State var selected: UUID?
    @State private var showingSheet = false
    @State private var addEventActive = false
    @State var eventType = "general"

    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.eventCards, id: \.uuid) { card in
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                        if self.mode?.wrappedValue == .active {
                            Button(action: {
                                self.managedObjectContext.delete(card)
                            }) {
                                Image("delete")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }.buttonStyle(PlainButtonStyle())

                            EventCardView(title: card.title ?? "title place holder", type: EventType(rawValue: card.type ?? EventType.general.rawValue), dateString: self.dateFormatter.string(from: card.start ?? Date()))
                        } else {
                            NavigationLink(destination: EventInfoView(card: card as! EventCard), tag: card.uuid!, selection: self.$selected) {
                                EventCardView(title: card.title ?? "title place holder", type: EventType(rawValue: card.type ?? EventType.general.rawValue), dateString: self.dateFormatter.string(from: card.start ?? Date()))
                                    .onTapGesture {
                                        self.selected = card.uuid
                                    }
                                    .onLongPressGesture {
                                        self.mode?.wrappedValue = .active
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
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
                    if self.mode?.wrappedValue == .inactive {
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
                                        self.eventType = "Food"
                                    }
                                ),
                                .default(
                                    Text("Transportation"),
                                    action: {
                                        self.addEventActive = true
                                        self.eventType = "Transportation"
                                    }
                                ),
                                .default(
                                    Text("General"),
                                    action: {
                                        self.addEventActive = true
                                        self.eventType = "General"
                                    }
                                ),
                                .destructive(Text("Dismiss")),
                            ])
                        }
                    }
                }
            }
        }.navigationBarItems(trailing: Button(action: {
            self.mode?.animation().wrappedValue = self.mode?.wrappedValue == .inactive ? .active : .inactive
        }, label: { Text(self.mode?.wrappedValue == .inactive ? "Edit" : "Done") }))
    }
}

struct EventCardListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EventCardListView()
        }
    }
}
