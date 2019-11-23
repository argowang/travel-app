//
//  SetCurrentLocationView.swift
//  tracker
//
//  Created by TechLead on 11/22/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import MapKit
import SwiftUI

struct SetCurrentLocationView: View {
    @Binding var newLocation: String
    @State var manager = CLLocationManager()
    @State var alert = false

    var body: some View {
        VStack {
            // ℹ️ need to restruct later
            MapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
                Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
            }
            RecordsListView(newLocation: self.$newLocation)
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
}

struct SetCurrentLocationView_Previews: PreviewProvider {
    @State static var newLocation = "Aruba"
    static var previews: some View {
        SetCurrentLocationView(newLocation: $newLocation)
    }
}
