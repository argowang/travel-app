import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var draftEvent: UserEvent

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @State var present: Bool = false
    private func dismiss() {
        mode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            if self.present {
                SetCurrentLocationView(place: draftEvent.place, draftPlace: Place(draftEvent.place), showMap: self.$present).environmentObject(PlaceFinder())
                    .transition(.move(edge: .bottom))
            } else {
                VStack {
                    Form {
//                    Section(header: Text("Location:")) {
//                        if draftEvent.type == .transportation {
//                            transportationLocationRow(origin: draftEvent.origin, destination: draftEvent.place)
//                        } else {
//                            locationRow(place: draftEvent.place)
//                        }
//                    }
                        Section {
                            Toggle(isOn: self.$present.animation(.easeIn(duration: 0.16))) {
                                Text("show map")
                            }
                        }

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
            }
        }
        .navigationBarTitle(Text("\(draftEvent.type.rawValue)"), displayMode: .inline)
        .navigationBarItems(leading: CancelButtonWithDismissAlert(dismiss),
                            trailing: Button(action: {
                                if self.draftEvent.saveToContext(self.managedObjectContext) {
                                    self.dismiss()
                                }
        }, label: { Text("Save") }).disabled(isSaveAllowed(draftEvent)))
        .resignKeyboardOnDragGesture()
        .navigationBarHidden(self.present)
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
    @State var present = false
    var body: some View {
        VStack {
            Image("location").resizable().frame(width: 50, height: 50).padding()

            Button(action: { self.present = true }) {
                Text("Location")
            }

            SetCurrentLocationView(place: self.place, draftPlace: Place(self.place), showMap: Binding.constant(true)).environmentObject(PlaceFinder())
        }
    }
}

struct transportationLocationRow: View {
    @ObservedObject var origin: Place
    @ObservedObject var destination: Place

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                NavigationLink(destination: SetCurrentLocationView(place: self.origin, draftPlace: Place(self.origin), showMap: Binding.constant(true)).environmentObject(PlaceFinder())) {
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
                NavigationLink(destination: SetCurrentLocationView(place: self.destination, draftPlace: Place(self.destination), showMap: Binding.constant(true)).environmentObject(PlaceFinder())) {
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
