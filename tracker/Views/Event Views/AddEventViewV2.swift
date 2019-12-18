//
//  AddEventViewV2.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Pages
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
        Pages(currentPage: self.$formPageIndex, navigationOrientation: .vertical) {
            Text("1")
            TextFieldWithDelete("Draft", text: self.$string)
        }.padding()
    }

    // Add custom validation logic here
    func isSaveAllowed(_: UserEvent) -> Bool {
        return draftEvent.title == ""
    }
}
