//
//  WeatherManager.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 19.05.2022.
//

import Foundation

final class WeatherManager: NSObject, ObservableObject {
    
    private var locationManager = LocationManager()
    private let dataFetcher: DataFetcher = NetworkDataFetcher()
    
    @Published var viewModel: WeatherViewModel?
    @Published var locationIsEmpty: Bool = false
    
    override init() {
        super.init()
        
        locationManager.onCompletion = { [weak self] location in
            
            guard let location = location else {
                self?.locationIsEmpty = true
                return
            }
            
            self?.dataFetcher.getWeather(lat: location.lat, lon: location.lon) { [weak self] weather, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let weather = weather else { return }
                
                self?.viewModel = WeatherViewModel(weather: weather, location: location)
            }
        }
    }
    
    func getWeather() {
        self.locationIsEmpty = false
        self.locationManager.requestLocation()
    }
}
