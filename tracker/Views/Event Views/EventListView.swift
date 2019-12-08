//
//  EventListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import CoreData
import SwiftUI
struct EventListView: View {
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
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        VStack {
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

                            EventDetailView(title: card.title ?? "title place holder", type: card.type ?? "general", dateString: self.dateFormatter.string(from: card.start ?? Date()))
                        } else {
                            NavigationLink(destination: EventInfoView(title: card.title ?? "title place holder", type: card.type ?? "general", dateString: self.dateFormatter.string(from: card.start ?? Date())), tag: card.uuid!, selection: self.$selected) {
                                EventDetailView(title: card.title ?? "title place holder", type: card.type ?? "general", dateString: self.dateFormatter.string(from: card.start ?? Date()))
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

            VStack {
                if self.mode?.wrappedValue == .inactive {
                    Button(action: {
                        if self.title != "" {}
                    }) {
                        NavigationLink(destination: AddEventView()) {
                            Text("Add event")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
            }
        }.navigationBarItems(trailing: Button(action: {
            self.mode?.animation().wrappedValue = self.mode?.wrappedValue == .inactive ? .active : .inactive
        }, label: { Text(self.mode?.wrappedValue == .inactive ? "Edit" : "Done") }))
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EventListView()
        }
    }
}
