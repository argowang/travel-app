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
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    @State var draftNewLocation: String = ""
    @State var draftSelectedCoordinate: CLLocationCoordinate2D?
    @State var alert = false
    @State var nearByPlaces: [MKMapItem] = []
    @State var cardPosition = CardPosition.middle

    @EnvironmentObject var placeFinder: PlaceFinder

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView(alert: $alert, nearByPlaces: $nearByPlaces, selectedCoordinate: $draftSelectedCoordinate, selectedLocation: $draftNewLocation)

                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
                }.edgesIgnoringSafeArea(.vertical)

            SlideOverCard(position: $cardPosition) {
                SearchBarView(cardPosition: self.$cardPosition, nearByPlaces: self.$nearByPlaces, newLocation: self.$draftNewLocation, selectedCoordinate: self.$draftSelectedCoordinate).environmentObject(self.placeFinder).padding(.bottom, 5)
            }.foregroundColor(.primary)
        }.edgesIgnoringSafeArea(.vertical)
            .navigationBarItems(trailing: Button(action: {
                self.newLocation = self.draftNewLocation
                self.selectedCoordinate = self.draftSelectedCoordinate
                self.mode.wrappedValue.dismiss()
            }, label: { Text("Save") }))

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
