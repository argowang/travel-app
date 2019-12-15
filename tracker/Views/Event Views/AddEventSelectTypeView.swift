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

    private func buttonAction() {
        navigateToAddEventView = true
        display = false
    }

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
                            ForEach(EventType.allValues, id: \.self) { type in
                                EventTypeButtonView(typeBinding: self.$eventType, type: type, action: self.buttonAction)
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
