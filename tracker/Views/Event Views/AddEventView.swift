import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var draftEvent: UserEvent

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    let animation = Animation.easeInOut(duration: 1.0)

    private func dismiss() {
        mode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            if draftEvent.type == .transportation {
                transportationLocationRow(origin: draftEvent.origin, destination: draftEvent.place)
            } else {
                locationRow(place: draftEvent.place)
            }
            VStack {
                Form {
                    Section(header: HStack {
                        Text("Title:")
                        Spacer()
                        Button(action: {
                            if self.draftEvent.type == .transportation {
                                self.draftEvent.title = "From \(self.draftEvent.origin.name) to \(self.draftEvent.place.name)"
                            } else {
                                self.draftEvent.title = self.draftEvent.place.name
                            }
                        }) {
                            Text("Sync with location")
                        }
                    }) {
                        HStack {
                            TextFieldWithDelete("Enter event title", text: $draftEvent.title)
                        }
                    }

                    Section {
                        datePicker(selectedDate: $draftEvent.dateForDate)
                        timePicker(selectedTime: $draftEvent.dateForTime)
                    }
                    Section(header: Text("💰 Price:")) {
                        HStack {
                            TextFieldWithDelete("Enter price here", text: $draftEvent.price)
                                .foregroundColor(.secondary)
                        }
                    }
                    Section(header: Text("👍 Rating:")) {
                        HStack {
                            StarRatingView(rating: $draftEvent.rating)
                        }
                    }
                    if draftEvent.type == .transportation {
                        Section(header: Text("Transportation")) {
                            VStack(alignment: .leading) {
                                transporatationMethodsSelectionRow(transportationMethod: $draftEvent.transportation)
                            }
                        }
                    }

                    Section(header: Text("Description")) {
                        HStack {
                            TextFieldWithDelete("Enter your description here", text: $draftEvent.eventDescription)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }.padding(.bottom, keyboard.currentHeight)
                .edgesIgnoringSafeArea(.bottom)
                .animation(.easeOut(duration: 0.16))
        }
        .navigationBarTitle(Text("\(draftEvent.type.rawValue)"))
        .navigationBarItems(leading: CancelButtonWithDismissAlert(dismiss),
                            trailing: Button(action: {
                                var cardToSave: EventCard!
                                if self.draftEvent.event != nil {
                                    cardToSave = self.draftEvent.event
                                } else {
                                    cardToSave = EventCard(context: self.managedObjectContext)
                                    cardToSave.uuid = UUID()
                                    self.draftEvent.parentTrip.addToEvents(cardToSave)
                                }

                                cardToSave.placeName = self.draftEvent.place.name
                                cardToSave.latitude = self.draftEvent.place.coordinate?.latitude ?? 0
                                cardToSave.longitude = self.draftEvent.place.coordinate?.longitude ?? 0

                                if self.draftEvent.type == .transportation {
                                    cardToSave.originName = self.draftEvent.origin.name
                                    cardToSave.originLatitude = self.draftEvent.origin.coordinate?.latitude ?? 0
                                    cardToSave.originLongitude = self.draftEvent.origin.coordinate?.longitude ?? 0
                                    cardToSave.transportation = self.draftEvent.transportation
                                }

                                cardToSave.title = self.draftEvent.title

                                cardToSave.start = self.draftEvent.calculatedDate
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
        }, label: { Text("Save") }).disabled(isSaveAllowed(draftEvent)))
    }

    // Add custom validation logic here
    func isSaveAllowed(_: UserEvent) -> Bool {
        return draftEvent.title == ""
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
            NavigationLink(destination: SetCurrentLocationView(place: self.place, draftPlace: Place(self.place)).environmentObject(PlaceFinder())) {
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
                NavigationLink(destination: SetCurrentLocationView(place: self.origin, draftPlace: Place(self.origin)).environmentObject(PlaceFinder())) {
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
                NavigationLink(destination: SetCurrentLocationView(place: self.destination, draftPlace: Place(self.destination)).environmentObject(PlaceFinder())) {
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
