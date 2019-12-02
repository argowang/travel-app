//
//  LocationManager.swift
//  tracker
//
//  Created by TechLead on 11/16/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject {
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastCity: String? {
        willSet {
            objectWillChange.send()
        }
    }

    func updateOnce() {
        lastCity = nil
        locationManager.requestLocation()
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)

        let georeader = CLGeocoder()
        if lastLocation != nil {
            georeader.reverseGeocodeLocation(lastLocation!) { places, err in

                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }

                self.lastCity = places?.first?.locality
            }
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
