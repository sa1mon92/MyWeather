//
//  ContentView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI
import CoreLocationUI
import MapKit

let startColor = Color(red: 115 / 255, green: 253 / 255, blue: 255 / 255)
let endColor = Color(red: 118 / 255, green: 214 / 255, blue: 255 / 255)
let dividerColor = Color.init(red: 108 / 255, green: 199 / 255, blue: 237 / 255)

struct ContentView: View {
    
    @StateObject var weatherManager = WeatherManager()
        
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        CurrentWeatherView(viewModel: $weatherManager.viewModel).frame(height: geometry.size.width / 1.5)
                        Divider().frame(height: 2).background(dividerColor)
                        HourlyWeatherView(viewModel: $weatherManager.viewModel).frame(height: geometry.size.width / 3)
                        Divider().frame(height: 2).background(dividerColor)
                        DailyWeatherView(viewModel: $weatherManager.viewModel).frame(height: (geometry.size.width / 8) * 10)
                        NavigationLink(destination: LocationView(), isActive: $weatherManager.locationIsEmpty) { EmptyView() }
                    }
                    .accentColor(.black).onAppear {
                        weatherManager.getWeather()
                    }
                }.statusBar(hidden: true)
            }
            .navigationBarHidden(true)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

