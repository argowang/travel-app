//
//  SearchBarView.swift
//  tracker
//
//  Created by TechLead on 11/23/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
//    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    @ObservedObject var placeFinder: PlaceFinder = PlaceFinder()

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("search", text: $placeFinder.searchString, onEditingChanged: { _ in
                        self.showCancelButton = true
                    }, onCommit: {
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
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        self.placeFinder.searchString = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)

            ForEach(self.placeFinder.results, id: \.self) { result in
                Text(result)
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
