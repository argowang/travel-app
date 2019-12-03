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
    @Binding var alert: Bool
    @Binding var nearByPlaces: [MKMapItem]
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var selectedLocation: String

    @EnvironmentObject var manager: LocationManager

    let map = MKMapView()

    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.region = region

        let trackButton = MKUserTrackingButton(mapView: map)
        trackButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        trackButton.layer.borderColor = UIColor.white.cgColor
        trackButton.layer.borderWidth = 1
        trackButton.layer.cornerRadius = 5
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        trackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        trackButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        map.addSubview(trackButton)
        map.showsCompass = false

        // TODO: Make these constraints work with other phones
        trackButton.centerXAnchor.constraint(equalTo: map.trailingAnchor, constant: -30).isActive = true
        trackButton.centerYAnchor.constraint(equalTo: map.centerYAnchor, constant: -140).isActive = true

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        map.isUserInteractionEnabled = true
        map.addGestureRecognizer(tapGesture)
        map.setUserTrackingMode(.none, animated: false)
        map.delegate = context.coordinator

        if let selected = self.selectedCoordinate {
            let point = MKPointAnnotation()
            point.coordinate = selected
            point.title = selectedLocation
            let region = MKCoordinateRegion(center: selected, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.region = region
            map.addAnnotation(point)
            context.coordinator.searchInMap()
        } else {
            if let location = self.manager.lastLocation {
                let point = MKPointAnnotation()
                point.coordinate = location.coordinate
                point.title = "Current"
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                map.region = region
                map.addAnnotation(point)
                context.coordinator.searchInMap()
            }
        }

        return map
    }

    func updateUIView(_ mapView: MKMapView, context _: UIViewRepresentableContext<MapView>) {
        if selectedCoordinate != nil {
            let region = MKCoordinateRegion(center: selectedCoordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedCoordinate!
            annotation.title = selectedLocation
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: true)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        let georeader: CLGeocoder

        init(parent1: MapView) {
            parent = parent1
            georeader = CLGeocoder()
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

        @objc func mapTap(sender: UITapGestureRecognizer) {
            let pointOnMap = parent.map.convert(sender.location(in: sender.view), toCoordinateFrom: parent.map)
            parent.map.removeAnnotations(parent.map.annotations)

            let annotationPoint = MKPointAnnotation()
            let location = CLLocation(latitude: pointOnMap.latitude, longitude: pointOnMap.longitude)
            georeader.reverseGeocodeLocation(location) { places, err in

                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }

                let place = places?.first?.name
                annotationPoint.title = place
                annotationPoint.coordinate = location.coordinate
                self.parent.map.removeAnnotations(self.parent.map.annotations)
                self.parent.map.addAnnotation(annotationPoint)

                self.parent.selectedCoordinate = location.coordinate
                self.parent.selectedLocation = place ?? ""
            }
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

        func mapView(_ mapView: MKMapView, didAdd _: [MKAnnotationView]) {
            if let userLocation = mapView.view(for: mapView.userLocation) {
                userLocation.isHidden = true
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var locationManager = CLLocationManager()
    @State static var alert = false
    @State static var nearBy: [MKMapItem] = []
    @State static var selectedCoordinate: CLLocationCoordinate2D?
    @State static var newLocation = ""
    static var previews: some View {
        MapView(alert: $alert, nearByPlaces: $nearBy, selectedCoordinate: $selectedCoordinate, selectedLocation: $newLocation)
    }
}
