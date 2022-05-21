//
//  NetworkDataFetcher.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Foundation

protocol DataFetcher {
    func getLocation(lat: Double, lon: Double, completion: @escaping ([Location]?, Error?) -> Void)
    func getLocation(city: String, completion: @escaping ([Location]?, Error?) -> Void)
    func getWeather(lat: Double, lon: Double, completion: @escaping (WeatherModel?, Error?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    private let networkService: Networking
    
    init(networkService: Networking = NetworkService()) {
        self.networkService = networkService
    }
    
    func getLocation(lat: Double, lon: Double, completion: @escaping ([Location]?, Error?) -> Void) {
        let parameters = ["lat": "\(lat)", "lon": "\(lon)", "limit": String(5), "appid": APIKey]
        request(urlString: locationByCoordinatesURL, parameters: parameters) { result, error in
            completion(result, error)
        }
    }
    
    func getLocation(city: String, completion: @escaping ([Location]?, Error?) -> Void) {
        let parameters = ["q": "\(city)", "limit": String(5), "appid": APIKey]
        request(urlString: locationByCityURL, parameters: parameters) { result, error in
            completion(result, error)
        }
    }
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (WeatherModel?, Error?) -> Void) {
        let parameters = ["lat": "\(lat)", "lon": "\(lon)", "exclude": "minutely,alerts", "units": "metric", "appid": APIKey]
        request(urlString: weatherURL, parameters: parameters) { result, error in
            completion(result, error)
        }
    }
    
    private func request<T: Codable>(urlString: String, parameters: [String : String], completion: @escaping (T?, Error?) -> Void) {
        
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
