//
//  CardListView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct CardListView: View {
    var body: some View {
            ScrollView {
                VStack {
                     CardView()
                     CardView()
                     CardView()
                     CardView()
                }
            } 
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
