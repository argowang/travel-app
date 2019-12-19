//
//  TripCardView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct TripCardView: View {
    var tripCard: TripCard

    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: UIImage(data: self.tripCard.image!, scale: 1.0)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(self.tripCard.title)
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .lineLimit(3)
                .padding()
        }
        .layoutPriority(100)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 2.5)
        )
        .padding()
    }
}

struct TripCardView_Previews: PreviewProvider {
    static var tripCard = TripCard()
    static var previews: some View {
        TripCardView(tripCard: tripCard)
    }
}
