//
//  TopView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 13.05.2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                Header().frame(height: geometry.size.width / 4)
                
                Divider().frame(height: 5).background(dividerColor)
                
                HStack(alignment: .center, spacing: 0) {
                    Text("19°C").font(Font.custom("DINCondensed-Bold", size: 110)).frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Details").font(.subheadline).fontWeight(.bold)
                        Divider().frame(width: geometry.size.width / 2 - 10, height: 2).background(dividerColor)
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Feels like").font(.subheadline)
                                Text("Wind").font(.subheadline)
                                Text("Humidity").font(.subheadline)
                                Text("Precip").font(.subheadline)
                                Text("Pressure").font(.subheadline)
                            }.frame(width: geometry.size.width / 4, alignment: .leading)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("19°C").font(.subheadline).fontWeight(.bold)
                                Text("7.2 m/s").font(.subheadline).fontWeight(.bold)
                                Text("57%").font(.subheadline).fontWeight(.bold)
                                Text("").font(.subheadline).fontWeight(.bold)
                                Text("1020 hPa").font(.subheadline).fontWeight(.bold)
                            }.frame(width: geometry.size.width / 4, alignment: .leading)
                        }
                    }.frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                }.frame(height: geometry.size.width / 2.5, alignment: .center)
                Spacer()
            }
        }
    }
}

struct Header: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .overlay {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("London, GB")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Scattered clouds")
                                .font(.subheadline)
                        }.frame(width: geometry.size.width / 2, alignment: .leading)
                        Spacer()
                        VStack {
                            Image(systemName: "cloud.sun").symbolRenderingMode(.palette).foregroundStyle(.black, .orange).font(.system(size: 70))
                        }.frame(width: geometry.size.width / 3, alignment: .leading)
                        
                    }.padding()
                }
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
    }
}
