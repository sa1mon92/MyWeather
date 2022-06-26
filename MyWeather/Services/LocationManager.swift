//
//  LocationManager.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 19.06.2022.
//

import Foundation
import CoreLocation
import Combine

enum CLocationState {
    case unknown
    case locationServicesDisabled
    case denied
    case restricted
    case notDetermined
    case authorizedAlways
    case authorizedWhenInUse
}
protocol LocationManagerProtocol {
    var locationPublisher: AnyPublisher<Location?, Never> { get }
    var locationStatePublisher: AnyPublisher<CLocationState, Never> { get }
}

final class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {

    private let locationPassthrough = PassthroughSubject<Location?, Never>()
    private let locationStatePassthrough = PassthroughSubject<CLocationState, Never>()
    private var cancellableSet: Set<AnyCancellable> = []
    private lazy var locationAPI = LocationAPI.shared
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        return lm
    }()
    var locationPublisher: AnyPublisher<Location?, Never> {
        return locationPassthrough.eraseToAnyPublisher()
    }
    var locationStatePublisher: AnyPublisher<CLocationState, Never> {
        return locationStatePassthrough.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        getLocation()
    }
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
    
    private func getLocation() {
        UserDefaults.standard.publisher(for: \.savedLocationWrappedValue, options: [.new, .initial])
            .sink(receiveValue: { [weak self] value in
                guard let data = value as? Data,
                      let location = Location(from: data)
                else {
                    self?.requestCLLocation()
                    return
                }
                RunLoop.main.perform {
                    self?.locationPassthrough.send(location)
                }
            })
            .store(in: &self.cancellableSet)
    }
    
    private func requestCLLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            locationStatePassthrough.send(.locationServicesDisabled)
            return
        }
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func getLocationFromAPI(location: CLLocation) {
        locationAPI.fetchLocations(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            .sink { locations in
                guard let location = locations.first else { return }
                UserDefaults.standard.saveLocation(location, completion: {})
            }
            .store(in: &self.cancellableSet)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getLocationFromAPI(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationStatePassthrough.send(.notDetermined)
        case .restricted:
            locationStatePassthrough.send(.restricted)
        case .denied:
            locationStatePassthrough.send(.denied)
        case .authorizedAlways:
            locationStatePassthrough.send(.authorizedAlways)
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationStatePassthrough.send(.authorizedWhenInUse)
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }
}
