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
    @ObservedObject var place: Place

    @State var draftPlace: Place = Place()
    @State var alert = false
    @State var nearByPlaces: [MKMapItem] = []
    @State var cardPosition = CardPosition.middle

    @EnvironmentObject var placeFinder: PlaceFinder
    @EnvironmentObject var manager: LocationManager

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView(nearByPlaces: $nearByPlaces, place: $draftPlace)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
                }.edgesIgnoringSafeArea(.vertical)

            SlideOverCard(position: $cardPosition) {
                SearchBarView(cardPosition: self.$cardPosition, nearByPlaces: self.$nearByPlaces, place: self.$draftPlace).environmentObject(self.placeFinder).padding(.bottom, 5)
            }
        }.edgesIgnoringSafeArea(.vertical)
            .navigationBarItems(trailing: Button(action: {
                self.place.name = self.draftPlace.name
                self.place.coordinate = self.draftPlace.coordinate
                print(self.place.name)
                self.mode.wrappedValue.dismiss()
            }, label: { Text("Save") }))
            .onAppear {
                // If user selected location before, we should honor it
                if self.place.coordinate != nil {
                    self.draftPlace = Place(self.place)
                } else {
                    // If user have not selected location before, we should provide a default coordinate of last location and take a best guess on the name
                    let georeader = CLGeocoder()
                    if let lastLocation = self.manager.lastLocation {
                        georeader.reverseGeocodeLocation(lastLocation) { places, err in
                            if err != nil {
                                print((err?.localizedDescription)!)
                                return
                            }

                            self.draftPlace = Place(places?.first?.name ?? "", lastLocation.coordinate)
                        }
                    }
                    self.manager.stopUpdating()
                }
            }.onDisappear {
                self.manager.continueUpdating()
            }
    }
}

struct SetCurrentLocationView_Previews: PreviewProvider {
    @State static var place = Place("Aruba", nil)
    static var previews: some View {
        SetCurrentLocationView(place: self.place).environmentObject(PlaceFinder())
    }
}
