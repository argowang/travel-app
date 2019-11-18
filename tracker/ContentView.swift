//
//  ContentView.swift
//  tracker
//
//  Created by TechLead on 11/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var locationManager = LocationManager()
    @FetchRequest(fetchRequest: Record.allRecordsFetchRequest()) var records: FetchedResults<Record>
    // ℹ️ Temporary in-memory storage for adding new blog ideas
    @State private var newLocation = ""
    
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
        List{
            Section(header: Text("Add Visited Place")) {
                VStack {
                    VStack {
                        TextField("Location", text: self.$newLocation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack {
                        Button(action: ({
                            // ❇️ Initializes new BlogIdea and saves using the @Environment's managedObjectContext
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
                                
                                // ℹ️ Reset the temporary in-memory storage variables for the next new blog idea!
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
                        HStack{
                            Text(record.location ?? "")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.5f", record.longitude))
                            Text(String(format: "%.5f", record.latitude))
                        }
                        
                        HStack{
                            Spacer()
                            record.date != nil ? Text(self.dateFormatter.string(from: record.date!)) : Text("N/A")
                        }
                        .font(.footnote)
                    }
                }
                .onDelete { (indexSet) in // Delete gets triggered by swiping left on a row
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
        .navigationBarItems(trailing: EditButton())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
