import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    @ObservedObject var place: Place = Place()
    @ObservedObject var origin: Place = Place()
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var draftEvent: UserEvent

    @EnvironmentObject var manager: LocationManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    let animation = Animation.easeInOut(duration: 1.0)

    var body: some View {
        VStack {
            if draftEvent.type == .transportation {
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
            VStack {
                List {
                    Section {
                        datePicker(selectedDate: $draftEvent.dateForDate)
                        timePicker(selectedTime: $draftEvent.dateForTime)
                    }
                    Section {
                        HStack {
                            Text("💰 Price:")
                            Spacer()
                                .frame(width: 180)
                            TextField("Enter price here", text: $draftEvent.price)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("👍 Rating:")
                            Spacer()
                            StarRatingView(rating: $draftEvent.rating)
                        }
                    }
                    if draftEvent.type == .transportation {
                        Section {
                            VStack(alignment: .leading) {
                                Text("Transportation")
                                transporatationMethodsSelectionRow(transportationMethod: $draftEvent.transportation)
                            }
                        }
                    }

                    Section {
                        HStack {
                            TextField("Enter your description here", text: $draftEvent.eventDescription)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }.padding(.bottom, keyboard.currentHeight)
                .edgesIgnoringSafeArea(.bottom)
                .animation(.easeOut(duration: 0.16))
        }
        .navigationBarTitle(Text("\(draftEvent.type.rawValue)"))
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
            if self.draftEvent.event != nil {
                cardToSave = self.draftEvent.event
            } else {
                cardToSave = EventCard(context: self.managedObjectContext)
                cardToSave.uuid = UUID()
                self.draftEvent.parentTrip.addToEvents(cardToSave)
            }

            cardToSave.title = self.place.name
            cardToSave.latitude = self.place.coordinate?.latitude ?? 0

            cardToSave.longitude = self.place.coordinate?.longitude ?? 0

            if self.draftEvent.type == .transportation {
                cardToSave.originTitle = self.origin.name
                cardToSave.originLatitude = self.origin.coordinate?.latitude ?? 0
                cardToSave.originLongitude = self.origin.coordinate?.longitude ?? 0

                cardToSave.transportation = self.draftEvent.transportation
            }

            let dateInt = (Int(self.draftEvent.dateForDate.timeIntervalSince1970) / (3600 * 24)) * (3600 * 24)
            let timeInt = Int(self.draftEvent.dateForTime.timeIntervalSince1970) % (3600 * 24)

            cardToSave.start = Date(timeIntervalSince1970: Double(dateInt + timeInt))
            cardToSave.type = self.draftEvent.type.rawValue
            cardToSave.rating = Int16(self.draftEvent.rating)
            cardToSave.price = self.draftEvent.price
            cardToSave.eventDescription = self.draftEvent.eventDescription

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
