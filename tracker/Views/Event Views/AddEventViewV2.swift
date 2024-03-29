//
//  AddEventViewV2.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct AddEventViewV2: View {
    @ObservedObject var draftEvent: UserEvent

    @EnvironmentObject var manager: LocationManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    let animation = Animation.easeInOut(duration: 1.0)
    @State var formPageIndex: Int = 0
    @State var string: String = ""
    var body: some View {
        VStack {
            SwipeView(draftEvent: self.draftEvent)
        }
        .navigationBarTitle(Text("\(draftEvent.type.rawValue)"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            if self.draftEvent.saveToContext(self.managedObjectContext) {
                self.mode.wrappedValue.dismiss()
            }
        }, label: { Text("Save") }) // .disabled(isSaveAllowed(draftEvent))
        )
    }

    // Add custom validation logic here
    func isSaveAllowed(_: UserEvent) -> Bool {
        return draftEvent.title == ""
    }
}
