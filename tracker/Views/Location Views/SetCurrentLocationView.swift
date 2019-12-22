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
    @ObservedObject var draftPlace: Place

    @State var alert = false
    @State var nearByPlaces: [MKMapItem] = []
    @State var cardPosition = CardPosition.middle

    @EnvironmentObject var placeFinder: PlaceFinder
    @EnvironmentObject var manager: LocationManager

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var showMap: Int

    private func dismiss() {
        mode.wrappedValue.dismiss()
    }

    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView(nearByPlaces: $nearByPlaces, place: draftPlace)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
                }.edgesIgnoringSafeArea(.vertical)
            HStack {
                Button(action: { self.showMap = 0 }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    self.place.name = self.draftPlace.name
                    self.place.coordinate = self.draftPlace.coordinate
                    self.showMap = 0
                }) {
                    Text("Save")
                }.edgesIgnoringSafeArea(.vertical)
            }.padding()
            SlideOverCard(position: $cardPosition) {
                SearchBarView(cardPosition: self.$cardPosition, nearByPlaces: self.$nearByPlaces, place: self.draftPlace).environmentObject(self.placeFinder).padding(.bottom, 5)
            }
        }
    }
}
