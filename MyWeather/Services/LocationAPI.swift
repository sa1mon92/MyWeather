//
//  LocationAPI.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 15.06.2022.
//

import Foundation
import Combine

class LocationAPI {
    static let shared = LocationAPI()
    private let APIKey = "YOUR API KEY OPENWEATHERMAP"
    private let baseURL = "https://api.openweathermap.org/geo/1.0/"
    
    private init() {}
    
    private func locationAsoluteURL(lat: Double, lon: Double) -> URL? {
        guard let queryURL = URL(string: baseURL + "reverse"),
              var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        else { return nil }
        
        urlComponents.queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                                    URLQueryItem(name: "lon", value: String(lon)),
                                    URLQueryItem(name: "limit", value: String(5)),
                                    URLQueryItem(name: "appid", value: APIKey)]
        return urlComponents.url
    }
    
    private func locationAsoluteURL(city: String) -> URL? {
        guard let queryURL = URL(string: baseURL + "direct"),
              var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        else { return nil }
        
        urlComponents.queryItems = [URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "limit", value: String(5)),
                                    URLQueryItem(name: "appid", value: APIKey)]
        return urlComponents.url
    }
    
    private func getPublisher(url: URL) -> AnyPublisher<[Location], Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [Location].self, decoder: JSONDecoder())
            .catch { error in Just([Location]()) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchLocations(lat: Double, lon: Double) -> AnyPublisher<[Location], Never> {
        guard let url = locationAsoluteURL(lat: lat, lon: lon) else {
            return Just([Location]())
                .eraseToAnyPublisher()
        }
        return getPublisher(url: url)
    }
    
    func fetchLocations(city: String) -> AnyPublisher<[Location], Never> {
        guard let url = locationAsoluteURL(city: city) else {
            return Just([Location]())
                .eraseToAnyPublisher()
        }
        return getPublisher(url: url)
    }
}
