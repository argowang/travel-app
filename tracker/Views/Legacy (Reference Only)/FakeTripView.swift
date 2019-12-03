//
//  FakeTripView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct FakeTripView: View {
    var body: some View {
        NavigationLink(destination: TripListView()) {
            Text("Your Trip")
        }
    }
}

struct FakeTripView_Previews: PreviewProvider {
    static var previews: some View {
        FakeTripView()
    }
}
