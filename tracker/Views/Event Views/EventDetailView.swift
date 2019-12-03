//
//  EventDetailView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct EventDetailView: View {
    var title: String
    var type: String
    var dateString: String

    var body: some View {
        VStack {
            HStack {
                Image(type == "Food" ? "food" : (type == "Transportation" ? "car" : "general"))
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()

                VStack(alignment: .leading) {
                    Text(self.dateString)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(self.title)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                .layoutPriority(100)

                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 2.5)
        )
        .padding([.top, .horizontal])
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var title = ""
    static var type = "general"
    static var dateString = ""
    static var previews: some View {
        EventDetailView(title: title, type: type, dateString: dateString)
    }
}
