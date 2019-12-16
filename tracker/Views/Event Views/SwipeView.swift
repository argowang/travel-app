//
//  SwipeView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Foundation
import SwiftUI
struct SwipeView: View {
    @State private var offset: CGFloat = 0
    @State private var index = 0

    let users = EventType.allValues
    let spacing: CGFloat = 10
    @State var string: String = ""

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: self.spacing) {
                    // ForEach(self.users) { user in
                    UserView()
                        .frame(width: geometry.size.width)
                    UserView()
                        .frame(width: geometry.size.width)
                    VStack {
                        TextFieldWithDelete("Enter price here", text: self.$string)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: geometry.size.width)
//                    }
                }
            }
            .content.offset(x: self.offset)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                    }
                    .onEnded { value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.users.count - 1 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                    }
            )
        }
    }
}

struct UserView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "pencil")
                .resizable()
                .aspectRatio(contentMode: .fit)
//            AvatarView(image: userModel.image)
//            NameView(name: userModel.name, age: userModel.age, hobby: userModel.hobby)
        }
        .shadow(radius: 12.0)
        .cornerRadius(12.0)
    }
}
