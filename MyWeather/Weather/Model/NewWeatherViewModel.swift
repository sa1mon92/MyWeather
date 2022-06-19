//
//  NewWeatherViewModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 17.06.2022.
//

import SwiftUI
import Combine

final class NewWeatherViewModel: ObservableObject {
    
    @Published var city: String = ""
    @Published var location: Location?
    @Published var locationIsEmpty: Bool = false
    @Published var weather: WeatherModel?
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var locationAPI = LocationAPI.shared
    private var weatherAPI = WeatherAPI.shared
    
    init() {
        subscribeLocation()
        subscribeWeather()
    }
    
    private func subscribeLocation() {
        UserDefaults.standard.publisher(for: \.savedLocationWrappedValue, options: [.new, .initial])
            .flatMap ({ (value) -> AnyPublisher<Location?, Never> in
                guard let data = value as? Data,
                      let location = Location(from: data)
                else {
                    self.locationIsEmpty = true
                    return Just(nil)
                        .eraseToAnyPublisher()
                }
                return Just(location)
                    .eraseToAnyPublisher()
            })
            .receive(on: RunLoop.main)
            .assign(to: \.location, on: self)
            .store(in: &self.cancellableSet)
    }
    
    private func subscribeWeather() {
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
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
}
