//
//  TripInfoView.swift
//  tracker
//
//  Created by 郭怡明 on 12/11/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Foundation
import SwiftUI

struct TripInfoView: View {
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
            HStack {
                Text("Trip Name : \(title)")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Text("Date is \(dateString)")
            }

            Spacer()
        }
    }
}

struct TripInfoView_Previews: PreviewProvider {
    static var title = ""
    static var dateString = ""
    static var previews: some View {
        TripInfoView(title: title, dateString: dateString)
    }
}
