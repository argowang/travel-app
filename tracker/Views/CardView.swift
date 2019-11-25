//
//  CardView.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @Binding var title: String
    @Binding var dateString: String
    
    var body: some View {
        
        VStack {
            Image("los-angeles")
                .resizable()
                .aspectRatio(contentMode: .fit)

            HStack {
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
        .shadow(radius: 16, y: 16)
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var title = ""
    @State static var dateString = ""
    static var previews: some View {
        CardView(title: $title, dateString: $dateString)
    }
}
