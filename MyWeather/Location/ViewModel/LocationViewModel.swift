//
//  LocationViewModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 15.06.2022.
//

import Foundation
import Combine

final class LocationViewModel: ObservableObject {
    
    @Published var city: String = ""
    @Published var locations = [Location]()
    private var cancellableSet: Set<AnyCancellable> = []
    private var locationAPI = LocationAPI.shared
    
    init() {
        $city
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (city: String) -> AnyPublisher<[Location], Never> in
                return self.locationAPI.fetchLocation(city: city)
            }
            .assign(to: \.locations, on: self)
            .store(in: &self.cancellableSet)
    }
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
}
