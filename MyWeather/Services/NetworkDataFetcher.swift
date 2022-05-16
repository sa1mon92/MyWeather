//
//  NetworkDataFetcher.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Foundation

enum RequestType {
    case locationByCity
    case locationByCoordinates
    case weather
}

protocol DataFetcher {
    func getLocation(lat: Double, lon: Double, completion: @escaping ([Location]?, Error?) -> Void)
    func getLocation(city: String, completion: @escaping ([Location]?, Error?) -> Void)
    func getWeather(lat: Double, lon: Double, completion: @escaping ([WeatherModel]?, Error?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    private let networkService: Networking
    private let APIKey = "9864ff6e9ec4d888c9d3358804fe7ef6"
    
    init(networkService: Networking = NetworkService()) {
        self.networkService = networkService
    }
    
    func getLocation(lat: Double, lon: Double, completion: @escaping ([Location]?, Error?) -> Void) {
        let parameters = ["lat": "\(lat)", "lat": "\(lat)", "limit": String(5), "appid": APIKey]
        request(type: .locationByCoordinates, parameters: parameters) { result, error in
            completion(result, error)
        }
    }
    
    func getLocation(city: String, completion: @escaping ([Location]?, Error?) -> Void) {
        let parameters = ["q": "\(city)", "limit": String(5), "appid": APIKey]
        request(type: .locationByCity, parameters: parameters) { result, error in
            completion(result, error)
        }
    }
    
    func getWeather(lat: Double, lon: Double, completion: @escaping ([WeatherModel]?, Error?) -> Void) {
        let parameters = ["lat": "\(lat)", "lat": "\(lat)", "exclude": "minutely,alerts", "appid": APIKey]
        request(type: .weather, parameters: parameters) { result, error in
            completion(result, error)
        }
    }
    
    private func request<T: Codable>(type: RequestType, parameters: [String : String], completion: @escaping (T?, Error?) -> Void) {
        
        var urlString: String
        
        switch type {
        case .locationByCity:
            urlString = "https://api.openweathermap.org/geo/1.0/direct"
        case .locationByCoordinates:
            urlString = "https://api.openweathermap.org/geo/1.0/reverse"
        case .weather:
            urlString = "https://api.openweathermap.org/data/2.5/onecall"
        }
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL for request: \(urlString)", code: 777)
            completion(nil, error)
            return
        }
        
        networkService.requestData(url: url, parameters: parameters) { data, error in
    
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            self.decode(from: data, to: T.self) { result, error in
                completion(result, nil)
            }

        }
    }
    
    private func decode<T: Codable>(from data: Data, to type: T.Type, completion: (T?, Error?) -> Void){
        
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(type.self, from: data)
            completion(result, nil)
        } catch let error as NSError {
            completion(nil, error)
        }
    }
}
