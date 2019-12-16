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

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context _: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        return view
    }

    func updateUIView(_ uiView: UITextView, context _: Context) {
        uiView.text = text
        print("text")
        print(text)
    }
}
