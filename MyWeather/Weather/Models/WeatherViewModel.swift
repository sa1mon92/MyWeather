//
//  WeatherViewModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 17.05.2022.
//

import Foundation
import SwiftUI

// MARK: - WeatherViewModel
struct WeatherViewModel {
    let cityName: String
    let countryCode: String
    let current: CurrentViewModel
    let hourly: [HourlyViewModel]
    let daily: [DailyViewModel]
    
    init(weather: WeatherModel, location: Location) {
        self.cityName = location.name
        self.countryCode = location.country
        self.current = CurrentViewModel(curreent: weather.current)
        
        var hourlyArray = [HourlyViewModel]()
        weather.hourly.forEach { hourly in
            let hourlyViewModel = HourlyViewModel(hourly: hourly)
            hourlyArray.append(hourlyViewModel)
        }
        self.hourly = hourlyArray
        
        
        var dailyArray = [DailyViewModel]()
        weather.daily.forEach { daily in
            let dailyViewModel = DailyViewModel(daily: daily)
            dailyArray.append(dailyViewModel)
        }
        self.daily = dailyArray
    }
}

// MARK: - CurrentViewModel
struct CurrentViewModel {
    let temp, feelsLike: Double
    let pressure, humidity, windSpeed: String
    let weather: [WeatherDescriptionViewModel]
    
    init(curreent: Current) {
        self.temp = curreent.temp
        self.feelsLike = curreent.feelsLike
        self.pressure = String(curreent.pressure)
        self.humidity = String(curreent.humidity)
        self.windSpeed = String(format: "%.1f", curreent.windSpeed)
        
        var weatherArray = [WeatherDescriptionViewModel]()
        curreent.weather.forEach { weather in
            let weatherViewModel = WeatherDescriptionViewModel(weather: weather)
            weatherArray.append(weatherViewModel)
        }
        self.weather = weatherArray
    }
}

// MARK: - HourlyViewModel
struct HourlyViewModel: Identifiable {
    let id = UUID()
    let dt: Int
    let temp: Double
    let weather: [WeatherDescriptionViewModel]
    
    var time: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let current = Date()
        let currentHourString = String(Calendar.current.component(.hour, from: current))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        if currentHourString == timeString.prefix(2) {
            return "Now"
        } else {
            return timeString
        }
    }
    
    init(hourly: Hourly) {
        self.dt = hourly.dt
        self.temp = hourly.temp
        
        var weatherArray = [WeatherDescriptionViewModel]()
        hourly.weather.forEach { weather in
            let weatherViewModel = WeatherDescriptionViewModel(weather: weather)
            weatherArray.append(weatherViewModel)
        }
        self.weather = weatherArray
    }
}

// MARK: - DailyViewModel
struct DailyViewModel: Identifiable {
    let id = UUID()
    let dt: Int
    let temp: TempViewModel
    let weather: [WeatherDescriptionViewModel]
    
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
    
    init(daily: Daily) {
        self.dt = daily.dt
        self.temp = TempViewModel(temp: daily.temp)
        
        var weatherArray = [WeatherDescriptionViewModel]()
        daily.weather.forEach { weather in
            let weatherViewModel = WeatherDescriptionViewModel(weather: weather)
            weatherArray.append(weatherViewModel)
        }
        self.weather = weatherArray
    }
}

// MARK: - WeatherDescriptionViewModel
struct WeatherDescriptionViewModel {
    let id: Int
    let main: String
    let description: String
    let iconName: String
    
    init(weather: Weather) {
        self.id = weather.id
        self.main = weather.main
        self.description = weather.description
        self.iconName = weather.icon
    }
}

// MARK: - TempViewModel
struct TempViewModel {
    let min, max: Double
    
    init(temp: Temp) {
        self.min = temp.min
        self.max = temp.max
    }
}

