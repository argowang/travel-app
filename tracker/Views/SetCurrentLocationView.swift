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
    @State var nearByPlaces: [MKMapItem] = []
    @State var onSearchBar = false

    @EnvironmentObject var placeFinder: PlaceFinder

    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView(manager: $manager, alert: $alert, nearByPlaces: $nearByPlaces)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
                }.edgesIgnoringSafeArea(.vertical)

            SlideOverCard(onSearchBar: $onSearchBar) {
                VStack {
                    SearchBarView(onSearchBar: self.$onSearchBar).environmentObject(self.placeFinder)

                    if self.placeFinder.searchString == "" {
                        List(self.nearByPlaces, id: \.self) { result in
                            Text(result.name!)
                        }
                    }
                    Spacer()
                }
            }
        }.edgesIgnoringSafeArea(.vertical)

//    //            RecordsListView(newLocation: self.$newLocation)
//    //                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
//            }
    }
}

struct SetCurrentLocationView_Previews: PreviewProvider {
    @State static var newLocation = "Aruba"
    static var previews: some View {
        SetCurrentLocationView(newLocation: $newLocation).environmentObject(PlaceFinder())
    }
}
