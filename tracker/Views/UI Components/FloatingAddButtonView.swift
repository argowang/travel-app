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

    private var destinationView: Content?
    private var extraAction: () -> Void
    private var isSheetMode: Bool

    init(destinationView: Content, extraAction: @escaping () -> Void = {}) {
        self.destinationView = destinationView
        self.extraAction = extraAction
        isSheetMode = true
    }

    init(extraAction: @escaping () -> Void = {}) {
        self.extraAction = extraAction
        isSheetMode = false
    }

    var body: some View {
        Group {
            if isSheetMode {
                sheetModeView
            } else {
                nonSheetModeView
            }
        }
    }

    private var nonSheetModeView: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.extraAction()
                }) {
                    Image("plus")
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
        }
    }

    private var sheetModeView: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.showSheet.toggle()
                    self.extraAction()
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
