//
//  MapView.swift
//  tracker
//
//  Created by TechLead on 11/22/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import MapKit
import SwiftUI

class CustomMKMarkerSubclass: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // We need to set the priority to required. Otherwise the annotation
            // would be blocked by userLocation annotation
            displayPriority = MKFeatureDisplayPriority.required
            canShowCallout = true
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var nearByPlaces: [MKMapItem]
    @ObservedObject var place: Place

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
        map.register(CustomMKMarkerSubclass.self, forAnnotationViewWithReuseIdentifier: "selectedID")

        if let selected = self.place.coordinate {
            let point = MKPointAnnotation()
            point.coordinate = selected
            point.title = place.name
            let region = MKCoordinateRegion(center: selected, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.region = region
            map.addAnnotation(point)
            context.coordinator.searchInMap()
        }

        return map
    }

    func updateUIView(_ mapView: MKMapView, context _: UIViewRepresentableContext<MapView>) {
        if place.coordinate != nil {
            let region = MKCoordinateRegion(center: place.coordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = place.coordinate!
            annotation.title = place.name
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

                let placeName = places?.first?.name
                annotationPoint.title = placeName
                annotationPoint.coordinate = location.coordinate
                self.parent.map.removeAnnotations(self.parent.map.annotations)
                self.parent.map.addAnnotation(annotationPoint)

                self.parent.place.coordinate = location.coordinate
                self.parent.place.name = placeName ?? ""
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
                userLocation.canShowCallout = false
                userLocation.isSelected = false
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var markerView: CustomMKMarkerSubclass

            guard !annotation.isKind(of: MKUserLocation.self) else {
                return nil
            }

            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "selectedID")
                as? CustomMKMarkerSubclass {
                dequeuedView.annotation = annotation
                markerView = dequeuedView
            } else {
                markerView = CustomMKMarkerSubclass(annotation: annotation, reuseIdentifier: "selectedID")
                markerView.canShowCallout = true
                markerView.calloutOffset = CGPoint(x: -5, y: 5)
                markerView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return markerView
        }
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var nearBy: [MKMapItem] = []
    @State static var place = Place("Aruba", nil)
    static var previews: some View {
        MapView(nearByPlaces: $nearBy, place: place)
    }
}
