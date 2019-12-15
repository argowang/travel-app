//
//  EventTypeButtonView.swift
//  tracker
//
//  Created by TechLead on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct EventTypeButtonView: View {
    @Binding var typeBinding: EventType
    let type: EventType
    let action: () -> Void

    var body: some View {
        VStack {
            Button(action: {
                self.typeBinding = self.type
                self.action()
            }) {
                type.getImage().resizable().frame(width: 60, height: 60)
                Text(type.rawValue).font(.subheadline)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct EventTypeButtonView_Previews: PreviewProvider {
    @State static var type: EventType = .general

    static var previews: some View {
        EventTypeButtonView(typeBinding: $type, type: .general, action: {})
    }
}
