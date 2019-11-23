//
//  DescriptionListView.swift
//  tracker
//
//  Created by TechLead on 11/22/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI

struct RecordsListView: View {
    @Binding var newLocation: String
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var locationManager = LocationManager()
    @FetchRequest(fetchRequest: Record.allRecordsFetchRequest()) var records: FetchedResults<Record>

    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }

    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }

    var body: some View {
        List {
            Section(header: Text("Add Visited Place")) {
                VStack {
                    VStack {
                        TextField("Name Currrent Visiting Location", text: self.$newLocation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack {
                        Button(action: ({
                            if self.newLocation != "" {
                                let record = Record(context: self.managedObjectContext)

                                record.location = self.newLocation
                                record.longitude = self.userLongitude
                                record.latitude = self.userLatitude
                                record.date = Date()
                                do {
                                    try self.managedObjectContext.save()
                                } catch {
                                    print(error)
                                }

                                self.newLocation = ""
                            }
                        })) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .imageScale(.large)
                                Text("Add Place")
                            }
                        }
                        .padding()
                    }
                }
            }
            .font(.headline)

            Section(header: Text("Travel Records")) {
                ForEach(self.records) { record in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(record.location ?? "")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.5f", record.longitude))
                            Text(String(format: "%.5f", record.latitude))
                        }

                        HStack {
                            Spacer()
                            record.date != nil ? Text(self.dateFormatter.string(from: record.date!)) : Text("N/A")
                        }
                        .font(.footnote)
                    }
                }
                .onDelete { indexSet in // Delete gets triggered by swiping left on a row
                    let recordToDelete = self.records[indexSet.first!]
                    self.managedObjectContext.delete(recordToDelete)

                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
            .font(.headline)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Visited Place List"))
    }
}

struct RecordsListView_Previews: PreviewProvider {
    @State static var newLocation = "Aruba"
    static var previews: some View {
        RecordsListView(newLocation: $newLocation)
    }
}
