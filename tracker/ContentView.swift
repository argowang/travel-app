//
//  ContentView.swift
//  tracker
//
//  Created by TechLead on 11/15/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import CoreData
import MapKit
import SwiftUI

struct DescriptionList: View {
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
        List {
            Section(header: Text("Add Visited Place")) {
                VStack {
                    VStack {
                        TextField("Name Currrent Visiting Location", text: self.$newLocation)
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
        .navigationBarItems(trailing: EditButton())
    }
}

struct MapView: UIViewRepresentable {
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    let map = MKMapView()

    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        return map
    }

    func updateUIView(_: MKMapView, context _: UIViewRepresentableContext<MapView>) {}

    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapView

        init(parent1: MapView) {
            parent = parent1
        }

        func searchInMap() {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "restaurant"
            request.region = parent.map.region
            let search = MKLocalSearch(request: request)
            search.start(completionHandler: { response, error in
                if response != nil {
                    for item in response!.mapItems {
                        self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                    }
                }
                if error != nil {
                    print((error?.localizedDescription)!)
                }
            })
        }

        func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            if let title = title {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = title

                parent.map.addAnnotation(annotation)
            }
        }

        func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .denied {
                parent.alert.toggle()
            }
        }

        func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last
            let point = MKPointAnnotation()

            let georeader = CLGeocoder()
            georeader.reverseGeocodeLocation(location!) { places, err in

                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }

                let place = places?.first?.locality
                point.title = place
                point.subtitle = "Current"
                point.coordinate = location!.coordinate
                self.parent.map.removeAnnotations(self.parent.map.annotations)
                self.parent.map.addAnnotation(point)

                let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.parent.map.region = region
                self.searchInMap()
            }
        }
    }
}

struct SetCurrentLocationView: View {
    @State var manager = CLLocationManager()
    @State var alert = false

    var body: some View {
        VStack {
            // ℹ️ need to restruct later
            MapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
                Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
            }
            DescriptionList()
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
}


struct ContentView: View {
    @State private var newLocation = ""
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SetCurrentLocationView()) {
                    Text("set location here")
                }
                .padding()
                TextField("Location", text: self.$newLocation)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
