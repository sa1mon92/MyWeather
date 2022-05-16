//
//  ViewModels.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Foundation

// MARK: - CurrentWeatherViewModel
struct CurrentWeatherViewModel {
    let temp, feelsLike, windSpeed: Double
    let pressure, humidity: Int
    let weather: [WeatherViewModel]
}

// MARK: - HourlyWeatherViewModel
struct HourlyWeatherViewModel {
    let dt: Int
    let temp: Double
    let weather: [WeatherViewModel]
}

// MARK: - DailyWeatherViewModel
struct DailyWeatherViewModel {
    let dt: Int
    let temp: Temp
    let weather: [WeatherViewModel]
}

// MARK: - WeatherViewModel
struct WeatherViewModel  {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
