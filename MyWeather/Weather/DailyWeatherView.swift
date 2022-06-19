//
//  DailyWeatherView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI

struct DailyWeatherView: View {
    
    @EnvironmentObject var viewModel: NewWeatherViewModel
    
    var body: some View {
        GeometryReader { geometry in
            List {
                if let dailyViewModels = viewModel.weather?.daily {
                    ForEach(dailyViewModels) { dailyViewModel in
                        DailyWeatherCell(viewModel: dailyViewModel)
                            .environmentObject(viewModel)
                            .frame(height: geometry.size.width / 8)
                            .listRowBackground(Color.white)
                    }
                }
            }.listStyle(.plain).hasScrollEnabled(false)
        }
    }
}

struct DailyWeatherCell: View {
    
    var viewModel: Daily
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(viewModel.date)")
                        .font(.subheadline)
                    Text("\(viewModel.weekDay)")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(viewModel.weekDayColor)
                }.frame(width: geometry.size.width / 2, alignment: .leading)
                Spacer()
                HStack {
                    Image("\(viewModel.weather.first?.icon ?? "Unknown")")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer()
                    Text("\(viewModel.temp.max.convertToString())°C")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(viewModel.temp.min.convertToString())°C")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.gray)
                }.frame(width: geometry.size.width / 2.3)
            }
            .background(.white)
        }
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView()
            .environmentObject(NewWeatherViewModel())
    }
}
