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
        NavigationLink(destination: LazyView(EventCardListView(tripUuid: UUID()))) {
            Text("Your Trip Events")
        }
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

struct FakeTripView_Previews: PreviewProvider {
    static var previews: some View {
        FakeTripView()
    }
}
