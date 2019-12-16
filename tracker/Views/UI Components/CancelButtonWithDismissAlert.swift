//
//  DismissAlert.swift
//  tracker
//
//  Created by TechLead on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct CancelButtonWithDismissAlert: View {
    @State var showsAlert = false

    private var destructionAction: () -> Void

    init(_ action: @escaping () -> Void = {}) {
        destructionAction = action
    }

    var body: some View {
        Button(action: {
            self.showsAlert = true
        }, label: {
            Text("Cancel")
        }).alert(isPresented: $showsAlert) {
            Alert(title: Text("Discard changes"), message: Text("Are you sure you want to discard all unsaved changes?"), primaryButton: .destructive(Text("Discard")) {
                self.destructionAction()
            }, secondaryButton: .cancel())
        }
    }
}

struct DismissAlert_Previews: PreviewProvider {
    @State static var showsAlert = true
    static var previews: some View {
        CancelButtonWithDismissAlert()
    }
}
