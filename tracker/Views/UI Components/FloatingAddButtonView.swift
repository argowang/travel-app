//
//  FloatingAddButtonView.swift
//  tracker
//
//  Created by TechLead on 12/14/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct FloatingAddButtonView<Content: View>: View {
    @State var showSheet = false

    private var destinationView: Content

    init(destinationView: Content) {
        self.destinationView = destinationView
    }

    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Image("plus")
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                .sheet(isPresented: $showSheet, onDismiss: {
                    //todo we should decide on dismiss behavior here
                }) {
                    self.destinationView
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
        }
    }
}

struct FloatingAddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAddButtonView(destinationView: Text("Hi"))
    }
}
