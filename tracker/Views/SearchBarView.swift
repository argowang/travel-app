//
//  SearchBarView.swift
//  tracker
//
//  Created by TechLead on 11/23/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @State private var showCancelButton: Bool = false

    @EnvironmentObject var placeFinder: PlaceFinder
    @EnvironmentObject var userViewConfig: UserViewConfig

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("search", text: $placeFinder.searchString, onEditingChanged: { _ in
                        self.showCancelButton = true
                        self.userViewConfig.inSearchView = true
                        self.userViewConfig.showRecommendPlaces = false
                    }, onCommit: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        print("onCommit")
                    }).foregroundColor(.primary)

                    Button(action: {
                        self.placeFinder.searchString = ""
                        self.userViewConfig.showRecommendPlaces = false
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
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        self.placeFinder.searchString = ""
                        self.userViewConfig.showRecommendPlaces = true
                        self.userViewConfig.inSearchView = false
                        self.showCancelButton = false
                    })
                        .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)

            if !userViewConfig.showRecommendPlaces {
                List(self.placeFinder.results, id: \.self) { result in
                    Text(result)
                }
            } else {
//                 show recommended places
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var userViewConfig = UserViewConfig()
    static var placeFinder = PlaceFinder()
    static var previews: some View {
        SearchBarView().environmentObject(userViewConfig).environmentObject(placeFinder)
    }
}
