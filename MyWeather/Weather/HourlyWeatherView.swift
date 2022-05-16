//
//  HourlyWeatherView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI

struct HourlyWeatherView: View {
    var body: some View {
        
        GeometryReader { geometry in
            LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .overlay {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<20) { _ in
                                VStack(spacing: 15) {
                                    Text("Now").font(Font.subheadline)
                                    Image(systemName: "cloud.sun").symbolRenderingMode(.palette).foregroundStyle(.black, .orange).font(.system(size: 30))
                                    Text("7°C").font(.title3).fontWeight(.medium)
                                }
                            }
                        }.padding()
                    }
                }
        }
    }
}

struct HourlyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherView()
    }
}
