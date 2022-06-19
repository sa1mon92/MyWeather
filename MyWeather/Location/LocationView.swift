//
//  LocationView.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 16.05.2022.
//

import SwiftUI

struct LocationView: View {
        
    var body: some View {
        VStack {
            LocationViewBody()
        }.navigationBarColor(backgroundColor: .white, titleColor: .black)
        .navigationTitle("Search location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationViewBody: View {
    
    private let backgroundColor = Color(red: 239/255, green: 243/255, blue: 244/255)
    @EnvironmentObject var viewModel: LocationViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter city name", text: $viewModel.city)
                    .padding()
                    .foregroundColor(.black)
            }
            .background(backgroundColor)
            .cornerRadius(10)
            .padding()

            List {
                ForEach(viewModel.locations) { location in
                    VStack {
                        if let state = location.state {
                            Text("\(location.localNames?.ru ?? location.name), \(state), \(location.country)")
                                .foregroundColor(.black)
                        } else {
                            Text("\(location.localNames?.ru ?? location.name), \(location.country)")
                                .foregroundColor(.black)
                        }
                    }.listRowBackground(Color.white)
                    .background(.white)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let intvalue = Int.random(in: 1..<100)
                        UserDefaults.standard.set(intvalue, forKey: "test")
                        UserDefaults.standard.saveLocation(location) { dismiss() }
                        
                    }
                }
            }.listStyle(.plain)
        }.background(.white)
            
    }
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
            .environmentObject(LocationViewModel())
    }
}
