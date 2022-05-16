//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

// MARK: - Current
struct Current: Codable {
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let windSpeed: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

// MARK: - Daily
struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Temp
struct Temp: Codable {
    let min, max: Double
}

