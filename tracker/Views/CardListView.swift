//
//  CardListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct CardListView: View {
    @State private var title = "LosAngeles"
    @State private var dateString = "2018.09.03-2018.09.10"
    var body: some View {
        ScrollView {
            VStack {
                CardView(title: $title, dateString: $dateString)
                CardView(title: $title, dateString: $dateString)
                CardView(title: $title, dateString: $dateString)
                CardView(title: $title, dateString: $dateString)
                CardView(title: $title, dateString: $dateString)
                CardView(title: $title, dateString: $dateString)
            }
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
