//
//  NewWeatherViewModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 17.06.2022.
//

import SwiftUI
import Combine

final class WeatherViewModel: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var weatherAPI = WeatherAPI.shared
    private var locationManager: LocationManagerProtocol = LocationManager()
    
    @Published var location: Location? {
        didSet {
            print("location setup")
        }
    }
    @Published var weather: WeatherModel?
    @Published var alertProvider = AlertProvider()
    @Published var activateLocationLink = false
    @Published var shouldShowAlert = false
        
    init() {
        subscribeLocation()
        subscribeLocationManager()
    }
    
    func checkLocation() {
        shouldShowAlert = location == nil && alertProvider.alert != nil
    }
    
    private func subscribeLocation() {
        $location
            .flatMap({(_location) -> AnyPublisher<WeatherModel?, Never> in
                guard let _location = _location else {
                    return Just(nil)
                        .eraseToAnyPublisher()
                }
                return self.weatherAPI.fetchWeather(from: _location)
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            })
            .receive(on: RunLoop.main)
            .assign(to: \.weather, on: self)
            .store(in: &self.cancellableSet)
    }
    
    private func subscribeLocationManager() {
        
        locationManager.locationPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.location, on: self)
            .store(in: &self.cancellableSet)
        
        locationManager.locationStatePublisher
            .sink(receiveValue: { state in
                switch state {
                case .locationServicesDisabled:
                    self.presentAlert(title: "Your location is not available", message: "Please enable Location Services") {
                        guard let url = URL(string:"App-Prefs:root=LOCATION_SERVICES") else { return }
                        if UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url, options: [:])
                        }
                    }
                case .denied:
                    self.presentAlert(title: "Your location is not available", message: "Please allow access to your location in the app settings") {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url, options: [:])
                        }
                    }
                case .restricted:
                    break
                case .notDetermined, .authorizedAlways, .authorizedWhenInUse, .unknown:
                    break
                }
            })
            .store(in: &self.cancellableSet)
    }
    
    private func presentAlert(title: String, message: String, primaryButtonAction: @escaping () -> Void) {
        alertProvider.alert = AlertProvider.Alert(title: title,
                                                  message: message,
                                                  primaryButtonText: "OK",
                                                  primaryButtonAction: primaryButtonAction,
                                                  secondaryButtonText: "Cancel",
                                                  secondaryButtonAction: { self.activateLocationLink = true })
        shouldShowAlert = true
    }
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
}
