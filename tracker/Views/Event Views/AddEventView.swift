import CoreData
import MapKit
import SwiftUI

struct AddEventView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @State var title = ""
    @State var defaultTitle = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var start = Date()
    @State var type = "General"
    @State var showDatePicker = false
    @EnvironmentObject var manager: LocationManager
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            eventTypeRow(type: $type)
            HStack {
                Text("Date is ")
                Button("\(start, formatter: dateFormatter)") {
                    self.showDatePicker = true
                }.sheet(
                    isPresented: self.$showDatePicker
                ) {
                    DatePicker(selection: self.$start, in: ...Date(), displayedComponents: .date) {
                        Text("Select a date")
                    }
                }
            }
            .padding()
            locationRows(newLocation: self.$title, autoPopulated: self.$defaultTitle)
                .padding()

            Button(action: {
                let card = EventCard(context: self.managedObjectContext)

                if self.title != "" {
                    card.title = self.title
                } else {
                    card.title = self.defaultTitle
                }

                card.start = self.start
                card.type = self.type

                do {
                    try self.managedObjectContext.save()
                    self.mode.wrappedValue.dismiss()
                } catch {
                    print(error)
                }
            }) {
                Text("Add event")
            }
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
    }
}

struct locationRows: View {
    @Binding var newLocation: String
    @Binding var autoPopulated: String
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        List {
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
