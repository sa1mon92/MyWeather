//
//  LocationManager.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 17.05.2022.
//

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
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    func requestLocation() {
        
        if let location = UserDefaults.standard.savedLocation() {
            onCompletion?(location)
        } else if CLLocationManager.locationServicesEnabled() {
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
            self.onCompletion?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        onCompletion?(nil)
    }
}
