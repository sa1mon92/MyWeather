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
                HeaderView(viewModel: viewModel).frame(height: geometry.size.width / 4 + 15)
                Divider().frame(height: 5).background(dividerColor)
                HStack(alignment: .center, spacing: 0) {
                    VStack(spacing: 30) {
                        Rectangle()
                        Text("\(viewModel?.current.temp.convertToString() ?? "-")°C").font(Font.custom("DINCondensed-Bold", size: 100))
                            .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                            .foregroundColor(.black)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Details")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Divider().frame(height: 2).background(dividerColor)
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Feels like")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("Wind")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("Humidity")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("Pressure")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }.frame(width: geometry.size.width / 4, alignment: .leading)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(viewModel?.current.feelsLike.convertToString() ?? "-")°C")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("\(viewModel?.current.windSpeed ?? "-") m/s")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("\(viewModel?.current.humidity ?? "-")%")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("\(viewModel?.current.pressure ?? "-") hPa")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }.frame(width: geometry.size.width / 4, alignment: .leading)
                        }
                    }.frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                }.frame(height: geometry.size.width / 2.5, alignment: .center)
                Spacer()
            }.background(.white)
        }
    }
}

struct HeaderView: View {
    
    var viewModel: WeatherViewModel?
    
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .overlay {
                    VStack(spacing: 40) {
                        Rectangle()
                        HStack(alignment: .center) {
                            NavigationLink(destination: LocationView()) {
                                Image(systemName: "magnifyingglass").font(.system(size: 30)).foregroundColor(.black)
                            }
                            VStack(alignment: .leading) {
                                Text("\(viewModel?.cityName ?? "Your location"), \(viewModel?.countryCode ?? "WW")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("\(viewModel?.current.weather.first?.description ?? "")")
                                    .font(.title3)
                                    .foregroundColor(.black)
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
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(PreviewWeatherModel.shared) { viewModel in
            CurrentWeatherView(viewModel: viewModel)
        }
    }
}
