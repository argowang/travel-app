//
//  SlideOverCardView.swift
//  tracker
//
//  Created by TechLead on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//
import SwiftUI

struct SlideOverCard<Content: View>: View {
    @GestureState private var dragState = DragState.inactive
    @State var position = CardPosition.middle
    @EnvironmentObject var userViewConfig: UserViewConfig

    var content: () -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, _ in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        return VStack() {
            HandleView().padding(.top, 2)
            self.content()
        }
        .frame(height: UIScreen.main.bounds.height)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: (userViewConfig.inSearchView ? CardPosition.top.rawValue : self.position.rawValue) + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = position.rawValue + drag.translation.height
        let positionAbove: CardPosition
        let positionBelow: CardPosition
        let closestPosition: CardPosition

        if cardTopEdgeLocation <= CardPosition.middle.rawValue {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }

        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }

        if verticalDirection > 0 {
            position = positionBelow
        } else if verticalDirection < 0 {
            position = positionAbove
        } else {
            position = closestPosition
        }
    }
}

enum CardPosition: CGFloat {
    case top = 100
    case middle = 500
    case bottom = 800
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case let .dragging(translation):
            return translation
        }
    }

    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

struct SlideOverCardView_Previews: PreviewProvider {
    static var previews: some View {
        SlideOverCard {
            Text("Hello")
        }
    }
}
