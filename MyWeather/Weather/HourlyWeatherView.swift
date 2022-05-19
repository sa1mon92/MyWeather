//
//  HourlyWeatherView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI

struct HourlyWeatherView: View {
    
    @Binding var viewModel: WeatherViewModel?
    
    var body: some View {
        
        GeometryReader { geometry in
            LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .overlay {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            if let hourlyViewModels = viewModel?.hourly {
                                ForEach(hourlyViewModels) { hourlyVM in
                                    VStack(spacing: 0) {
                                        Text("\(hourlyVM.time)").font(Font.subheadline)
                                        Image("\(viewModel?.current.weather.first?.iconName ?? "Unknown")")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                        Text("\(hourlyVM.temp.convertToString())°C").font(.title3).fontWeight(.medium)
                                    }
                                }
                            }
                        }.padding()
                    }
                }
        }
    }
}

//struct HourlyWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        HourlyWeatherView()
//    }
//}
