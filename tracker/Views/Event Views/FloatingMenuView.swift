//
//  FloatingMenuView.swift
//  tracker
//
//  Created by TechLead on 12/20/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct FloatingMenuView: View {
    @EnvironmentObject var trip: TripCard
    @State var showMenuItem1 = false
    @State var showMenuItem2 = false
    @State var showMenuItem3 = false

    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    if showMenuItem1 {
                        MenuItem(icon: .food)
                    }
                    if showMenuItem2 {
                        MenuItem(icon: .transportation)
                    }
                    if showMenuItem3 {
                        MenuItem(icon: .general)
                    }
                    Button(action: {
                        self.showMenu()
                    }) {
                        Image("plus")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    func showMenu() {
        withAnimation {
            self.showMenuItem3.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                self.showMenuItem2.toggle()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.showMenuItem1.toggle()
            }
        }
    }
}

struct MenuItem: View {
    @EnvironmentObject var manager: LocationManager
    @EnvironmentObject var trip: TripCard

    var icon: EventType

    var body: some View {
        ZStack {
            NavigationLink(destination: AddEventView(draftEvent: UserEvent(self.icon, self.trip, self.manager))) {
                icon.getImage()
                    .resizable()
                    .frame(width: 55, height: 55)
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .transition(.move(edge: .trailing))
    }
}
