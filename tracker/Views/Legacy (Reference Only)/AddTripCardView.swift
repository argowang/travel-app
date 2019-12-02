//
//  AddTripCardView.swift
//  tracker
//
//  Created by bingxin on 11/27/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct AddTripCardView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: AddEventView()) {
                VStack {
                    Image("add")
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("add a new trip event!")
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                        }
                        .layoutPriority(100)
                    }
                    .padding()
                }
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 2.5)
                )
                .padding([.top, .horizontal])
            }.navigationBarTitle(Text("trip"))
        }
    }
}

struct AddTripCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripCardView()
    }
}
