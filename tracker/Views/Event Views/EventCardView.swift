//
//  EventDetailView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import SwiftUI

struct EventCardView: View {
    var title: String
    var type: EventType
    var dateString: String

    var body: some View {
        VStack {
            HStack {
                type.getImage()
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
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var title = ""
    static var type = EventType.general
    static var dateString = ""
    static var previews: some View {
        EventCardView(title: title, type: type, dateString: dateString)
    }
}
