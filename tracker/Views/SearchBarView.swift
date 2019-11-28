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
    @EnvironmentObject var placeFinder: PlaceFinder

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("search", text: $placeFinder.searchString, onEditingChanged: { _ in
                        self.showCancelButton = true
                        self.cardPosition = CardPosition.top
                    }, onCommit: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                List(self.placeFinder.results, id: \.self) { result in
                    Text(result)
                }.resignKeyboardOnDragGesture()
            } else {
                List(self.nearByPlaces, id: \.self) { result in
                    Text(result.name!)
                }.resignKeyboardOnDragGesture()
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var placeFinder = PlaceFinder()
    @State static var cardPosition: CardPosition = CardPosition.middle
    @State static var nearByPlaces: [MKMapItem] = []
    static var previews: some View {
        SearchBarView(cardPosition: $cardPosition, nearByPlaces: $nearByPlaces)
    }
}
