//
//  MultilineTextView.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Combine
import SwiftUI
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
    }
}
