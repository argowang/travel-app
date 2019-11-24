//
//  FormListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import MapKit
import SwiftUI

let userViewConfig = UserViewConfig()
struct FormListView: View {
    @State private var newLocation = ""
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SetCurrentLocationView(newLocation: self.$newLocation).environmentObject(userViewConfig)) {
                    Text("set location here")
                }
                .padding()
                Text("Location: \(self.newLocation)")
            }
            .navigationBarTitle("Your Trip")
        }
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView()
    }
}
