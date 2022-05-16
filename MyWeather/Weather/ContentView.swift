//
//  ContentView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI

let startColor = Color(red: 115 / 255, green: 253 / 255, blue: 255 / 255)
let endColor = Color(red: 118 / 255, green: 214 / 255, blue: 255 / 255)
let dividerColor = Color.init(red: 108 / 255, green: 199 / 255, blue: 237 / 255)

struct ContentView: View {
    
    var dataFetcher: DataFetcher = NetworkDataFetcher()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        CurrentWeatherView().frame(height: geometry.size.width / 1.5)
                        Divider().frame(height: 2).background(dividerColor)
                        HourlyWeatherView().frame(height: geometry.size.width / 3)
                        Divider().frame(height: 2).background(dividerColor)
                        DailyWeatherView().frame(height: (geometry.size.width / 8) * 10)
                    }
                }.statusBar(hidden: true)
            }
            .navigationBarHidden(true)
            
        }.accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
