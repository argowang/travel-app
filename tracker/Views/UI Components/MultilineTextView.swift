//
//  MultilineTextView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Combine
import SwiftUI
import TextView

struct MultilineTextViewWithOverlayColor: View {
    @Binding var text: String
    @State var isEditing = false
    var color = Color.gray
    var lineWidth = 1.5
    var cornerRadius = 10

    var body: some View {
        TextView(text: $text, isEditing: $isEditing)
            .frame(height: 70)
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                    .stroke(color, lineWidth: CGFloat(lineWidth))
                    .opacity(0.1)
            )
    }
} 
