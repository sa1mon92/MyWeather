//
//  LocationManager.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 17.05.2022.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var dataFetcher: DataFetcher = NetworkDataFetcher()
    
    var onCompletion: ((Location?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        return lm
    }()
    
    func requestLocation() {
        if let location = UserDefaults.standard.savedLocation() {
            onCompletion?(location)
            return
        } else if CLLocationManager.locationServicesEnabled() && locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        } else if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            onCompletion?(nil)
        }
    }
    
    private func getLocation(location: CLLocation) {
        
        dataFetcher.getLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { locations, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let location = locations?.first else { return }
            UserDefaults.standard.saveLocation(location) {
            }
            self.onCompletion?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        switch manager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: Not Determined")
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            onCompletion?(nil)
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Authorized Always")
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            print("DEBUG: Authorized When In Use")
        @unknown default:
            break
        }
    }
}
