//
//  TopView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI
import URLImage

struct CurrentWeatherView: View {
        
    @Binding var viewModel: WeatherViewModel?
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                HeaderView(viewModel: viewModel).frame(height: geometry.size.width / 4)
                Divider().frame(height: 5).background(dividerColor)
                HStack(alignment: .center, spacing: 0) {
                    Text("\(viewModel?.current.temp.convertToString() ?? "-")°C").font(Font.custom("DINCondensed-Bold", size: 110)).frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Details").font(.subheadline).fontWeight(.bold)
                        Divider().frame(height: 2).background(dividerColor)
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Feels like").font(.subheadline)
                                Text("Wind").font(.subheadline)
                                Text("Humidity").font(.subheadline)
                                Text("Pressure").font(.subheadline)
                            }.frame(width: geometry.size.width / 4, alignment: .leading)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(viewModel?.current.feelsLike.convertToString() ?? "-")°C").font(.subheadline).fontWeight(.bold)
                                Text("\(viewModel?.current.windSpeed ?? "-") m/s").font(.subheadline).fontWeight(.bold)
                                Text("\(viewModel?.current.humidity ?? "-")%").font(.subheadline).fontWeight(.bold)
                                Text("\(viewModel?.current.pressure ?? "-") hPa").font(.subheadline).fontWeight(.bold)
                            }.frame(width: geometry.size.width / 4, alignment: .leading)
                        }
                    }.frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                }.frame(height: geometry.size.width / 2.5, alignment: .center)
                Spacer()
            }
        }
    }
}

struct HeaderView: View {
    
    var viewModel: WeatherViewModel?
    
    var body: some View {
        
        GeometryReader { geometry in
            LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .overlay {
                    HStack(alignment: .center) {
                        NavigationLink(destination: LocationView()) {
                            Image(systemName: "magnifyingglass").font(.system(size: 30)).foregroundColor(.black)
                        }
                        VStack(alignment: .leading) {
                            Text("\(viewModel?.cityName ?? "Your location"), \(viewModel?.countryCode ?? "WW")")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("\(viewModel?.current.weather.first?.description ?? "")")
                                .font(.title3)
                        }.frame(width: geometry.size.width / 2, alignment: .leading)
                        Spacer()
                        VStack {
                            Image("\(viewModel?.current.weather.first?.iconName ?? "Unknown")")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }.frame(width: geometry.size.width / 3, alignment: .leading)
                        
                    }.padding()
                }
        }
    }
}

//struct TopView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentWeatherView()
//    }
//}
