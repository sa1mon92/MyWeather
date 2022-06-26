//
//  ContentView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject var viewModel: WeatherViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @State var activateLink = false
    @State var statusBarHidden = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            CurrentWeatherView()
                                .environmentObject(viewModel)
                                .frame(height: geometry.size.width / 4 + geometry.size.width / 2.5 + 20)
                            Divider().frame(height: 2).background(dividerColor)
                            HourlyWeatherView()
                                .environmentObject(viewModel)
                                .frame(height: geometry.size.width / 3)
                            Divider().frame(height: 2).background(dividerColor)
                            DailyWeatherView()
                                .environmentObject(viewModel)
                                .frame(height: (geometry.size.width / 8) * 10)
                            NavigationLink(destination: LocationView().environmentObject(LocationViewModel()), isActive: $viewModel.activateLocationLink) { EmptyView() }
                        }.hidden(viewModel.weather == nil ? true : false)
                            .accentColor(.black)
                        VStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.gray)
                            Text("Loading weather...").foregroundColor(.black)
                        }.hidden(viewModel.weather == nil ? false : true)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }.background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        print($0)
                        if $0 > 0 && statusBarHidden == false {
                            statusBarHidden = true
                        } else if $0 < 0 && statusBarHidden == true {
                            statusBarHidden = false
                        }
                    }
                        .onAppear{
                            viewModel.checkLocation()
                        }
                        .alert(isPresented: $viewModel.shouldShowAlert) {
                            guard let alert = viewModel.alertProvider.alert else { fatalError("Alert not available") }
                            return Alert(alert)
                        }
                }.coordinateSpace(name: "scroll")         }
            .navigationBarHidden(true)
        }
        .statusBar(hidden: statusBarHidden)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.checkLocation()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}
