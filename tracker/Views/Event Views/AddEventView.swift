import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    @State var title = ""
    @State var defaultTitle = ""
    @State var selectedDate = Date()
    @State var selectedTime = Date()
    @State var type = EventType.general
    @State var rating = 5

    @State var card: EventCard?
    @State var defaultCoordinate: CLLocationCoordinate2D?
    @State var selectedCoordinate: CLLocationCoordinate2D?

    @EnvironmentObject var manager: LocationManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            eventTypeRow(type: $type)

            datePicker(selectedDate: self.$selectedDate)
                .padding()

            timePicker(selectedTime: self.$selectedTime)
                .padding()

            locationRows(newLocation: self.$title, autoPopulated: self.$defaultTitle, selectedCoordinate: self.$selectedCoordinate)
                .padding()

            HStack {
                Text("Rating:")
                StarRatingView(rating: self.$rating)
            }

            Spacer()
        }.onAppear {
            let georeader = CLGeocoder()
            if let lastLocation = self.manager.lastLocation {
                georeader.reverseGeocodeLocation(lastLocation) { places, err in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    self.defaultCoordinate = lastLocation.coordinate
                    self.defaultTitle = places?.first?.locality ?? ""
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            var cardToSave: EventCard!
            var newCard: Bool = false
            if self.card != nil {
                cardToSave = self.card
            } else {
                cardToSave = EventCard(context: self.managedObjectContext)
                cardToSave.uuid = UUID()
                newCard = true
            }
            if self.title != "" {
                cardToSave.title = self.title
                cardToSave.latitude = self.selectedCoordinate?.latitude ?? 0
                cardToSave.longitude = self.selectedCoordinate?.longitude ?? 0
            } else {
                cardToSave.title = self.defaultTitle
                cardToSave.latitude = self.defaultCoordinate?.latitude ?? 0
                cardToSave.longitude = self.defaultCoordinate?.longitude ?? 0
            }

            cardToSave.start = self.selectedDate
            cardToSave.type = self.type.rawValue
            cardToSave.rating = Int16(self.rating)

            do {
                try self.managedObjectContext.save()
                self.mode.wrappedValue.dismiss()
                if !newCard {
                    self.mode.wrappedValue.dismiss()
                }
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
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

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
    @Binding var type: EventType

    var body: some View {
        VStack {
            Text("Event Type: \(type.rawValue)")
                .padding()
            HStack {
                Button(action: { self.type = EventType.general
                }) {
                    Text("General")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(20)

                Button(action: { self.type = EventType.transportation
                }) {
                    Text(EventType.transportation.rawValue)
                        .fontWeight(.bold)
                }
                .foregroundColor(Color.white)
                .padding(8)
                .background(Color.purple)
                .cornerRadius(20)

                Button(action: { self.type = EventType.food
                }) {
                    Text(EventType.food.rawValue)
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
