import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    @State var title = ""
    @State var defaultTitle = ""
    @Environment(\.managedObjectContext) var managedObjectContext 
    @State var selectedDate = Date()
    @State var selectedTime = Date()
    @State var type = "General"
    @ObservedObject var manager = LocationManager() 
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            eventTypeRow(type: $type) 

            datePicker(selectedDate: self.$selectedDate)
                .padding()

            timePicker(selectedTime: self.$selectedTime)
                .padding()

            locationRows(newLocation: self.$title, autoPopulated: self.$defaultTitle) 
                .padding()
            
            Spacer()
        }.onAppear {
            let georeader = CLGeocoder()
            if let lastLocation = self.manager.lastLocation {
                georeader.reverseGeocodeLocation(lastLocation) { places, err in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }

                    self.defaultTitle = places?.first?.locality ?? ""
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            let card = EventCard(context: self.managedObjectContext)

            if self.title != "" {
                card.title = self.title
            } else {
                card.title = self.defaultTitle
            }

            card.start = self.selectedDate
            card.type = self.type

            do {
                try self.managedObjectContext.save()
                self.mode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
        }, label: { Text("Save") }))
    }
}

struct datePicker: View {
    @Binding var selectedDate: Date
    @State var showDatePicker = false

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var body: some View {
        HStack {
            Text("Date is ")
            Button("\(selectedDate, formatter: dateFormatter)") {
                self.showDatePicker = true
            }.sheet(
                isPresented: self.$showDatePicker
            ) {
                DatePicker(selection: self.$selectedDate, in: ...Date(), displayedComponents: .date) {
                    Text("Select a date")
                }
            }
        }
    }
}

struct timePicker: View {
    @Binding var selectedTime: Date
    @State var showDatePicker = false

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min ... max
    }

    var body: some View {
        HStack {
            Text("Time is ")
            Button("\(selectedTime, formatter: dateFormatter)") {
                self.showDatePicker = true
            }.sheet(
                isPresented: self.$showDatePicker
            ) {
                DatePicker(
                    selection: self.$selectedTime,
                    in: self.dateClosedRange,
                    displayedComponents: .hourAndMinute
                ) {
                    Text("Select a time")
                }
            }
        }
    }
}

struct locationRows: View {
    @Binding var newLocation: String
    @Binding var autoPopulated: String
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View { 
            HStack {
                Text("Location:")
                NavigationLink(destination: SetCurrentLocationView(newLocation: self.$newLocation, selectedCoordinate: self.$selectedCoordinate).environmentObject(PlaceFinder())) {
                    if self.newLocation == "" {
                        Text("\(self.autoPopulated)")
                    } else {
                        Text("\(self.newLocation)")
                    }
                }
                .padding()
            }
    }
}

struct eventTypeRow: View {
    @Binding var type: String

    var body: some View {
        VStack {
            Text("Event Type: \(type)")
                .padding()
            HStack {
                Button(action: { self.type = "general"
                }) {
                    Text("General")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(20)

                Button(action: { self.type = "transportation"
                }) {
                    Text("transportation")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.purple)
                .cornerRadius(20)

                Button(action: { self.type = "food"
                }) {
                    Text("food")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.green)
                .cornerRadius(20)
            }
        }
    }
}

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}
