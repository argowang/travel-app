//
//  ViewExtension.swift
//  tracker
//
//  Created by TechLead on 11/23/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing()
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    // Keyboard would disappear when user drag the window
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
