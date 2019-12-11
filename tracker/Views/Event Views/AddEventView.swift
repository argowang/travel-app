import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    @State var selectedDate = Date()
    @State var selectedTime = Date()
    @State var type = EventType.general
    @State var rating = 5
    @State var transporatation = ""
    @State var card: EventCard?

    @ObservedObject var place: Place = Place()
    @ObservedObject var origin: Place = Place()

    @EnvironmentObject var manager: LocationManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    let animation = Animation.easeInOut(duration: 1.0)

    var body: some View {
        VStack {
            if type == .transportation {
                transportationLocationRow(origin: origin, destination: place)
            } else {
                ZStack {
                    VStack {
                        LocationAirplaneIcon().frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 50)
                        Spacer()
                            .frame(height: 50)
                    }
                    locationRow(place: self.place)
                }
            }

            List {
                Section {
                    datePicker(selectedDate: self.$selectedDate)
                    timePicker(selectedTime: self.$selectedTime)
                }
                Section {
                    HStack {
                        Text("Rating:")
                        StarRatingView(rating: self.$rating)
                    }
                }
                if type == .transportation {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Transportation")
                            transporatationMethodsSelectionRow(transportationMethod: self.$transporatation)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationBarTitle(Text("\(type.rawValue)"))
        .onAppear {
            if self.place.name == "" {
                let georeader = CLGeocoder()
                if let lastLocation = self.manager.lastLocation {
                    georeader.reverseGeocodeLocation(lastLocation) { places, err in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        self.place.name = places?.first?.locality ?? ""
                        self.place.coordinate = lastLocation.coordinate
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            var cardToSave: EventCard!
            if self.card != nil {
                cardToSave = self.card
            } else {
                cardToSave = EventCard(context: self.managedObjectContext)
                cardToSave.uuid = UUID()
            }

            cardToSave.title = self.place.name
            cardToSave.latitude = self.place.coordinate?.latitude ?? 0
            cardToSave.longitude = self.place.coordinate?.longitude ?? 0

            if self.type == .transportation {
                cardToSave.originTitle = self.origin.name
                cardToSave.originLatitude = self.origin.coordinate?.latitude ?? 0
                cardToSave.originLongitude = self.origin.coordinate?.longitude ?? 0

                cardToSave.transportation = self.transporatation
            }

            let dateInt = (Int(self.selectedDate.timeIntervalSince1970) / (3600 * 24)) * (3600 * 24)
            let timeInt = Int(self.selectedTime.timeIntervalSince1970) % (3600 * 24)

            cardToSave.start = Date(timeIntervalSince1970: Double(dateInt + timeInt))
            cardToSave.type = self.type.rawValue
            cardToSave.rating = Int16(self.rating)

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
        DatePicker(selection: self.$selectedDate, in: ...Date(), displayedComponents: .date) {
            Text("Date")
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

    var body: some View {
        DatePicker(
            selection: self.$selectedTime,
            displayedComponents: .hourAndMinute
        ) {
            Text("Time")
        }
    }
}

struct locationRow: View {
    @ObservedObject var place: Place

    var body: some View {
        HStack {
            Image("location").resizable().frame(width: 50, height: 50).padding()
            Text("Location:")
            NavigationLink(destination: SetCurrentLocationView(place: self.place).environmentObject(PlaceFinder())) {
                Text("\(self.place.name)")
            }
            Spacer()
        }
    }
}

struct transportationLocationRow: View {
    @ObservedObject var origin: Place
    @ObservedObject var destination: Place

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                NavigationLink(destination: SetCurrentLocationView(place: self.origin).environmentObject(PlaceFinder())) {
                    Text("\(self.origin.name == "" ? "From" : self.origin.name)")
                }
            }.frame(minWidth: 0, maxWidth: .infinity)

            VStack {
                Button(action: {
                    let temp = Place(self.origin)
                    self.origin.name = self.destination.name
                    self.origin.coordinate = self.destination.coordinate
                    self.destination.name = temp.name
                    self.destination.coordinate = temp.coordinate
                }) {
                    Image(systemName: "arrow.right.arrow.left").foregroundColor(.blue)
                }
            }.frame(minWidth: 0, maxWidth: .infinity)

            VStack {
                NavigationLink(destination: SetCurrentLocationView(place: self.destination).environmentObject(PlaceFinder())) {
                    Text("\(self.destination.name == "" ? "Destination" : self.destination.name)")
                }
            }.frame(minWidth: 0, maxWidth: .infinity)

        }.padding(.horizontal)
    }
}

struct transporatationMethodsSelectionRow: View {
    @Binding var transportationMethod: String

    var body: some View {
        VStack {
            Picker(selection: $transportationMethod, label: Text("What is your favorite color?")) {
                Text("🚶").tag("walk")
                Text("🚴‍♀️").tag("bike")
                Text("🚗").tag("car")
                Text("🚌").tag("bus")
                Text("✈️").tag("airplaine")
                Text("🚢").tag("ship")
                Text("🚇").tag("metro")
                Text("🚄").tag("train")
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(place: Place())
    }
}
