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
    @State var cardPosition = CardPosition.middle

    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    @EnvironmentObject var placeFinder: PlaceFinder

    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView(manager: $manager, alert: $alert, nearByPlaces: $nearByPlaces, selectedCoordinate: $selectedCoordinate)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
                }.edgesIgnoringSafeArea(.vertical)

            SlideOverCard(position: $cardPosition) {
                SearchBarView(cardPosition: self.$cardPosition, nearByPlaces: self.$nearByPlaces, newLocation: self.$newLocation, selectedCoordinate: self.$selectedCoordinate).environmentObject(self.placeFinder).padding(.bottom, 5)
            }.foregroundColor(.primary)
        }.edgesIgnoringSafeArea(.vertical)

//    //            RecordsListView(newLocation: self.$newLocation)
//    //                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
//            }
    }
}

struct SetCurrentLocationView_Previews: PreviewProvider {
    @State static var newLocation = "Aruba"
    @State static var selectedCoordinate: CLLocationCoordinate2D?
    static var previews: some View {
        SetCurrentLocationView(newLocation: $newLocation, selectedCoordinate: $selectedCoordinate).environmentObject(PlaceFinder())
    }
}
