//
//  ViewTripEventInfo.swift
//  tracker
//
//  Created by Bingxin Zhu on 11/28/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Foundation
import SwiftUI

struct EventInfoView: View {
    var title: String
    var dateString: String

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        VStack {
            Text("Location : \(title)")
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Date is \(dateString)")

            Spacer()
        }
    }
}

struct ViewTripEventInfoView_Previews: PreviewProvider {
    static var title = ""
    static var dateString = ""
    static var previews: some View {
        EventInfoView(title: title, dateString: dateString)
    }
}
