//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import SwiftUI

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
struct Hourly: Codable, Identifiable, Equatable {
    let id = UUID()
    let dt: Int
    let temp: Double
    let weather: [Weather]
    
    var time: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case weather
    }
    
    static func == (lhs: Hourly, rhs: Hourly) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
    
}

// MARK: - Daily
struct Daily: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let temp: Temp
    let weather: [Weather]
    
    var date: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }
    
    var weekDay: String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let currentDate = Date()
        
        let weekDayFormatter = DateFormatter()
        weekDayFormatter.locale = Locale(identifier: "en")
        weekDayFormatter.dateFormat = "EEEE"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd/MM/yyyy"
        
        if dayFormatter.string(from: date) == dayFormatter.string(from: currentDate) {
            return "Today"
        } else {
            return weekDayFormatter.string(from: date)
        }
    }
    
    var weekDayColor: Color {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let weekDayFormatter = DateFormatter()
        weekDayFormatter.locale = Locale(identifier: "en")
        weekDayFormatter.dateFormat = "EEEE"
        let weekDay = weekDayFormatter.string(from: date)
        
        switch weekDay {
        case "Saturday", "Sunday":
            return Color.red
        default:
            return Color.black
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case weather
    }
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

