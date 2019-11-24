//
//  HandleView.swift
//  tracker
//
//  Created by TechLead on 11/24/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct HandleView: View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}

struct HandleView_Previews: PreviewProvider {
    static var previews: some View {
        HandleView()
    }
}
