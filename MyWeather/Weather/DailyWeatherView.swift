//
//  DailyWeatherView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI

struct DailyWeatherView: View {
    var body: some View {
        GeometryReader { geometry in
            List {
                ForEach(0..<10) { _ in
                    DailyWeatherCell().frame(height: geometry.size.width / 8)
                }
            }.listStyle(.plain).hasScrollEnabled(false)
        }
    }
}

struct DailyWeatherCell: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(spacing: 3) {
                    Text("15 june").font(.subheadline)
                    Text("Today").font(.title3).fontWeight(.medium)
                }.frame(width: geometry.size.width / 2, alignment: .leading)
                Spacer()
                HStack {
                    Image(systemName: "cloud.sun").symbolRenderingMode(.palette).foregroundStyle(.black, .orange).font(.system(size: 30))
                    Spacer()
                    Text("7°C").font(.title3).fontWeight(.medium)
                    Spacer()
                    Text("1°C").font(.subheadline).fontWeight(.medium).foregroundColor(Color.gray)
                }.frame(width: geometry.size.width / 2.3)
            }
        }
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView()
            .previewInterfaceOrientation(.portrait)
    }
}
