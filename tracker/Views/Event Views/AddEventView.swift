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

    let animation = Animation.easeInOut(duration: 1.0)

    var body: some View {
        VStack {
            ZStack {
                VStack {
                    LocationAirplaneIcon().frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 50)
                    Spacer()
                        .frame(height: 50)
                }
                locationRows(newLocation: self.$title, autoPopulated: self.$defaultTitle, selectedCoordinate: self.$selectedCoordinate)
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
            }
            .listStyle(GroupedListStyle())
        }
        .navigationBarTitle(Text("\(type.rawValue)"))
        .onAppear {
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
            if self.card != nil {
                cardToSave = self.card
            } else {
                cardToSave = EventCard(context: self.managedObjectContext)
                cardToSave.uuid = UUID()
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

struct locationRows: View {
    @Binding var newLocation: String
    @Binding var autoPopulated: String
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        HStack {
            Image("location").resizable().frame(width: 50, height: 50).padding()
            Text("Location:")
            NavigationLink(destination: SetCurrentLocationView(newLocation: self.$newLocation, selectedCoordinate: self.$selectedCoordinate).environmentObject(PlaceFinder())) {
                if self.newLocation == "" {
                    Text("\(self.autoPopulated)")
                } else {
                    Text("\(self.newLocation)")
                }
            }
            Spacer()
        }
    }
}

struct AddTripEventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}
