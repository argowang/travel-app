//
//  LocationAirplaneIcon.swift
//  tracker
//
//  Created by Bingxin Zhu on 12/9/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct LocationAirplaneIcon: View {
    var body: some View {
        Example9()
    }
}

struct LocationAirplaneIcon_Previews: PreviewProvider {
    static var previews: some View {
        LocationAirplaneIcon()
    }
}

struct Example9: View {
    @State private var flag = false

    var body: some View {
        GeometryReader { proxy in
            Image(systemName: "airplane").resizable().foregroundColor(Color.blue)
                .frame(width: 50, height: 50).offset(x: -25, y: -25)
                .modifier(FollowEffect(pct: self.flag ? 1 : 0, path: InfinityShape.createInfinityPath(in: CGRect(x: 0, y: 0, width:
                    proxy.size.width,
                                                                                                                 height: 100)), rotate: true))
                .onAppear {
                    withAnimation(Animation.linear(duration: 6.0).repeatForever(autoreverses: false)) {
                        self.flag.toggle()
                    }
                }
        }
    }
}

struct FollowEffect: GeometryEffect {
    var pct: CGFloat = 0
    let path: Path
    var rotate = true

    var animatableData: CGFloat {
        get { return pct }
        set { pct = newValue }
    }

    func effectValue(size _: CGSize) -> ProjectionTransform {
        if !rotate {
            let pt = percentPoint(pct)

            return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
        } else {
            // Calculate rotation angle, by calculating an imaginary line between two points
            // in the path: the current position (1) and a point very close behind in the path (2).
            let pt1 = percentPoint(pct)
            let pt2 = percentPoint(pct - 0.01)

            let a = pt2.x - pt1.x
            let b = pt2.y - pt1.y

            let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi

            let transform = CGAffineTransform(translationX: pt1.x, y: pt1.y).rotated(by: CGFloat(angle))

            return ProjectionTransform(transform)
        }
    }

    func percentPoint(_ percent: CGFloat) -> CGPoint {
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

        let f = pct > 0.999 ? CGFloat(1 - 0.001) : pct
        let t = pct > 0.999 ? CGFloat(1) : pct + 0.001
        let tp = path.trimmedPath(from: f, to: t)

        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }
}

struct InfinityShape: Shape {
    func path(in rect: CGRect) -> Path {
        return InfinityShape.createInfinityPath(in: rect)
    }

    static func createInfinityPath(in rect: CGRect) -> Path {
        let height = rect.size.height / 6
        let width = rect.size.width

        var path = Path()

        path.move(to: CGPoint(x: width, y: height))
        path.addCurve(to: CGPoint(x: width, y: height), control1: CGPoint(x: 0, y: height), control2: CGPoint(x: 0, y: height))

        path.move(to: CGPoint(x: width, y: height))
        path.addCurve(to: CGPoint(x: width, y: height), control1: CGPoint(x: width, y: height), control2: CGPoint(x: width, y: height))

        return path
    }
}
