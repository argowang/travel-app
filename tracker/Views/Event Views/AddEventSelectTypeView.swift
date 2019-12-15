//
//  AddEventSelectTypeView.swift
//  tracker
//
//  Created by TechLead on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct AddEventSelectTypeView: View {
    @Binding var display: Bool
    @Binding var navigateToAddEventView: Bool
    @Binding var eventType: EventType

    var body: some View {
        Group {
            if display {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.vertical)
                    // This VStack is the popup
                    VStack {
                        VStack {
                            Text("Pick event type")
                            Divider()
                        }.padding(.vertical)

                        HStack(spacing: 20) {
                            VStack {
                                Button(action: {
                                    self.navigateToAddEventView = true
                                    self.eventType = .food
                                    self.display = false

                                }) {
                                    EventType.food.getImage().resizable().frame(width: 60, height: 60)
                                    Text(EventType.food.rawValue).font(.subheadline)
                                }.buttonStyle(PlainButtonStyle())
                            }

                            VStack {
                                Button(action: {
                                    self.navigateToAddEventView = true
                                    self.eventType = .transportation
                                    self.display = false

                                }) {
                                    EventType.transportation.getImage().resizable().frame(width: 60, height: 60)
                                    Text(EventType.transportation.rawValue).font(.subheadline)
                                }.buttonStyle(PlainButtonStyle())
                            }

                            VStack {
                                Button(action: {
                                    self.navigateToAddEventView = true
                                    self.eventType = .general
                                    self.display = false

                                }) {
                                    EventType.general.getImage().resizable().frame(width: 60, height: 60)
                                    Text(EventType.general.rawValue).font(.subheadline)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }

                        Button(action: {
                            self.display = false
                        }) {
                            Text("Close")
                        }.padding()
                    }
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(20).shadow(radius: 20)
                }
            }
        }
    }
}
