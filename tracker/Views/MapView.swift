//
//  MapView.swift
//  tracker
//
//  Created by TechLead on 11/22/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    @Binding var nearByPlaces: [MKMapItem]
    let map = MKMapView()

    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.region = region

        let Userbutton = MKUserTrackingButton(mapView: map)
        Userbutton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        Userbutton.layer.borderColor = UIColor.white.cgColor
        Userbutton.layer.borderWidth = 1
        Userbutton.layer.cornerRadius = 5
        Userbutton.translatesAutoresizingMaskIntoConstraints = false
        Userbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        Userbutton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        map.addSubview(Userbutton)

        // TODO: Make these constraints work with other phones
        Userbutton.centerXAnchor.constraint(equalTo: map.trailingAnchor, constant: -30).isActive = true
        Userbutton.centerYAnchor.constraint(equalTo: map.centerYAnchor, constant: -240).isActive = true

        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.requestLocation()
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
                    self.parent.nearByPlaces = response!.mapItems
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

        func locationManager(_: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var locationManager = CLLocationManager()
    @State static var alert = false
    @State static var nearBy: [MKMapItem] = []
    static var previews: some View {
        MapView(manager: $locationManager, alert: $alert, nearByPlaces: $nearBy)
    }
}
