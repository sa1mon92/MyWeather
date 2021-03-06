//
//  WeatherAPI.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 15.06.2022.
//

import Foundation
import Combine

class WeatherAPI {
    static let shared = WeatherAPI()
    private let baseURL = "https://api.openweathermap.org/data/2.5/onecall"
    private var subscriptions = Set<AnyCancellable>()

    private func weatherAsoluteURL(lat: Double, lon: Double) -> URL? {
        guard let queryURL = URL(string: baseURL),
              var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        else { return nil }
        
        urlComponents.queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                                    URLQueryItem(name: "lon", value: String(lon)),
                                    URLQueryItem(name: "exclude", value: "minutely,alerts"),
                                    URLQueryItem(name: "units", value: "metric"),
                                    URLQueryItem(name: "appid", value: APIKey)]
        return urlComponents.url
    }
    
    func fetchWeather(from location: Location) -> Future<WeatherModel?, APIError> {
        return Future<WeatherModel?, APIError> { [unowned self] promise in
            guard let url = self.weatherAsoluteURL(lat: location.lat, lon: location.lon) else { return promise(.failure(.urlError(URLError(URLError.unsupportedURL)))) }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...300 ~= httpResponse.statusCode else {
                        throw APIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                })
                .decode(type: WeatherModel.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                        case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(.genericError))
                        }
                    }
                } receiveValue: { promise(.success($0)) }
                .store(in: &self.subscriptions)
        }
    }
    
}

