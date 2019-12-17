//
//  TripCardView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct TripCardView: View {
    var title: String
    var dateString: String
    var image: UIImage?

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Image(uiImage: self.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit) 
                Text(self.title)
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .padding()
            }
            .layoutPriority(100)
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 2.5)
        )
        .padding([.top, .horizontal])
    }
}

struct TripCardView_Previews: PreviewProvider {
    static var title = ""
    static var dateString = ""
    static var previews: some View {
        TripCardView(title: title, dateString: dateString)
    }
}
