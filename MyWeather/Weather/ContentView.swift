//
//  ContentView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI
import CoreLocation

let startColor = Color(red: 115 / 255, green: 253 / 255, blue: 255 / 255)
let endColor = Color(red: 118 / 255, green: 214 / 255, blue: 255 / 255)
let dividerColor = Color.init(red: 108 / 255, green: 199 / 255, blue: 237 / 255)

struct ContentView: View {
    
    @StateObject var weatherManager = WeatherManager()
        
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            CurrentWeatherView(viewModel: $weatherManager.viewModel).frame(height: geometry.size.width / 4 + geometry.size.width / 2.5 + 20)
                            Divider().frame(height: 2).background(dividerColor)
                            HourlyWeatherView(viewModel: $weatherManager.viewModel).frame(height: geometry.size.width / 3)
                            Divider().frame(height: 2).background(dividerColor)
                            DailyWeatherView(viewModel: $weatherManager.viewModel)
                                .frame(height: (geometry.size.width / 8) * 10)
                            NavigationLink(destination: LocationView(), isActive: $weatherManager.locationIsEmpty) { EmptyView() }
                        }.hidden(weatherManager.viewModel == nil ? true : false)
                        .accentColor(.black).onAppear {
                            weatherManager.getWeather()
                        }
                        VStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.gray)
                            Text("Loading weather...").foregroundColor(.black)
                        }.hidden(weatherManager.viewModel == nil ? false : true)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            
                    }.background(.white)
                }.statusBar(hidden: false)
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

