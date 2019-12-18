//
//  EventDetailView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/2/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import SwiftUI

struct EventCardView: View {
    var eventCard: EventCard

    var body: some View {
        VStack {
            HStack {
                EventType(rawValue: self.eventCard.type).getImage()
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()

                VStack(alignment: .leading) {
                    Text(self.eventCard.formattedStartString)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(self.eventCard.title)
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

struct EventCardView_Previews: PreviewProvider {
    static var card = EventCard()
    static var previews: some View {
        EventCardView(eventCard: card)
    }
}
