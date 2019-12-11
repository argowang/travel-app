//
//  SearchBarView.swift
//  tracker
//
//  Created by TechLead on 11/23/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import MapKit
import SwiftUI

struct SearchBarView: View {
    @State private var showCancelButton: Bool = false
    @Binding var cardPosition: CardPosition
    @Binding var nearByPlaces: [MKMapItem]

    @ObservedObject var place: Place
    
    @EnvironmentObject var placeFinder: PlaceFinder
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    let greeting = "Hello, world!"

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("search", text: $placeFinder.searchString, onEditingChanged: { _ in
                        self.showCancelButton = true
                        self.cardPosition = CardPosition.top
                    }, onCommit: {
                        UIApplication.shared.endEditing()
                        print("onCommit")
                    }).foregroundColor(.primary)

                    Button(action: {
                        self.placeFinder.searchString = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(placeFinder.searchString == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)

                if showCancelButton {
                    Button("Cancel", action: {
                        UIApplication.shared.endEditing()
                        self.placeFinder.searchString = ""
                        self.showCancelButton = false
                        self.cardPosition = CardPosition.bottom
                    })
                        .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)

            if placeFinder.searchString != "" {
                OnNotEmptyStringSearchBarView(cardPosition: $cardPosition, nearByPlaces: $nearByPlaces, place: place)
            } else {
                Text("Suggested Nearby Places").font(.footnote).foregroundColor(Color.gray).padding(.leading)

                OnEmptyStringSearchBarView(cardPosition: $cardPosition, nearByPlaces: $nearByPlaces, place: place)
            }
        }
    }
}

struct OnNotEmptyStringSearchBarView: View {
    @Binding var cardPosition: CardPosition
    @Binding var nearByPlaces: [MKMapItem]

    @ObservedObject var place: Place

    @EnvironmentObject var placeFinder: PlaceFinder
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        List(self.placeFinder.results, id: \.self) { result in
            Button(action: {
                let request = MKLocalSearch.Request(completion: result)
                let search = MKLocalSearch(request: request)
                search.start(completionHandler: { response, error in
                    if error == nil {
                        self.place.coordinate = response?.mapItems[0].placemark.coordinate
                    }
                })

                self.placeFinder.searchString = ""
                UIApplication.shared.endEditing()
                self.place.name = result.title
                self.cardPosition = CardPosition.bottom
            }) {
                VStack(alignment: .leading) {
                    Text(result.title).font(.headline)
                    Text(result.subtitle).font(.footnote).foregroundColor(Color.gray)
                }
            }
        }.resignKeyboardOnDragGesture()
    }
}

struct OnEmptyStringSearchBarView: View {
    @Binding var cardPosition: CardPosition
    @Binding var nearByPlaces: [MKMapItem]
    @ObservedObject var place: Place
    @EnvironmentObject var placeFinder: PlaceFinder
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        List(self.nearByPlaces, id: \.self) { result in
            Button(action: {
                self.placeFinder.searchString = ""
                UIApplication.shared.endEditing()
                self.place.name = result.name!
                self.place.coordinate = result.placemark.coordinate
                self.cardPosition = CardPosition.bottom
            }) {
                VStack(alignment: .leading) {
                    Text(result.name!).font(.headline)

                    // TODO: Handle optional values here
                    Text("\(result.placemark.subThoroughfare!) \(result.placemark.thoroughfare!),  \(result.placemark.subAdministrativeArea!), \(result.placemark.administrativeArea!)").font(.footnote).foregroundColor(Color.gray)
                }
            }

        }.resignKeyboardOnDragGesture()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var placeFinder = PlaceFinder()
    @State static var cardPosition: CardPosition = CardPosition.middle
    @State static var nearByPlaces: [MKMapItem] = []
    @State static var place = Place("Aruba", nil)
    static var previews: some View {
        SearchBarView(cardPosition: $cardPosition, nearByPlaces: $nearByPlaces, place: place)
    }
}
