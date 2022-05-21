//
//  PreviewWeatherModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 19.05.2022.
//

import Foundation

class PreviewWeatherModel {
    
    private static let location = Location(name: "London",
                                    localNames: LocalNames(en: "London", ru: "Лондон"),
                                    lat: 51.5073219,
                                    lon: -0.1276474,
                                    country: "GB",
                                    state: "England")
    
    private static let currentWeather = Current(temp: 10,
                                         feelsLike: 15,
                                         pressure: 1020,
                                         humidity: 44,
                                         windSpeed: 4.63,
                                         weather: [Weather(id: 802,
                                                           main: "Clouds",
                                                           description: "scattered clouds",
                                                           icon: "03d")])
    
    private static let hourlyWeather = Hourly(dt: 1652972400, temp: 10, weather: [Weather(id: 802,
                                                                                       main: "Clouds",
                                                                                       description: "scattered clouds",
                                                                                       icon: "03d")])
    
    private static let dailyWeather = Daily(dt: 1652972400, temp: Temp(min: 5, max: 10), weather: [Weather(id: 802,
                                                                                       main: "Clouds",
                                                                                       description: "scattered clouds",
                                                                                       icon: "03d")])
    
    static var shared = WeatherViewModel(weather: WeatherModel(current: currentWeather, hourly: Array.init(repeating: hourlyWeather, count: 48), daily: Array.init(repeating: dailyWeather, count: 8)), location: location)
    
    private init() { }
}
