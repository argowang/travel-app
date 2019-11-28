//
//  ContentView.swift
//  tracker
//
//  Created by TechLead on 11/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import MapKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Entry point:")
                NavigationLink(destination: FormListView()) {
                    Text("FormListView")
                }
                .padding()
                Text("Entry point:")
                NavigationLink(destination: FakeCardEntryPointView()) {
                    Text("FakeCardEntryPointView")
                }
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea([.top])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
