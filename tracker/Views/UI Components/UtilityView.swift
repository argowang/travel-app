//
//  FakeTripView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

struct RefreshView: View {
    @State var refresh: Bool
    var body: some View {
        VStack{
            if self.refresh {
                Text("Hi").hidden()
            } else {
                Text("Hello").hidden()
            }
        }.hidden()
    }
}
