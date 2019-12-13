//
//  AddTripView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import SwiftUI

struct AddTripView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title = ""

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            HStack {
                Button(
                    action: { self.presentationMode.wrappedValue.dismiss()
                    }
                ) {
                    Text("Dismiss")
                        .padding()
                }
                .foregroundColor(.gray)

                Spacer()
                Button(action: {
                    let card = TripCard(context: self.managedObjectContext)
                    card.title = self.title
                    do {
                        try self.managedObjectContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }) {
                    Text("Save")
                        .padding()
                }
            }
            HStack {
                Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                ) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 70, height: 70)
                        .opacity(0.1)
                }
                .foregroundColor(.gray)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "camera.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                )
                .padding()

                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.gray)
                    .frame(height: 70)
                    .opacity(0.1)
                    .overlay(
                        TextField("Enter your trip name", text: $title)
                            .padding()
                    )
                    .padding()
            }

            Spacer()
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
