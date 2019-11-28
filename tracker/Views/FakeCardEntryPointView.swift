//
//  FakeCardEntryPointView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/28/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct FakeCardEntryPointView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    cardRow()
                }
                .navigationBarTitle("Your Trip")
            }
        }
    }
}

struct cardRow: View {
    @State private var newLocation = ""
    var body: some View {
        HStack {
            Text("card:")
            NavigationLink(destination: CardListView()) {
                Text("text")
            }
            .padding()
        }
    }
}

struct FakeCardEntryPointView_Previews: PreviewProvider {
    static var previews: some View {
        FakeCardEntryPointView()
    }
}
