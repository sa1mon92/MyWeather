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
        }
        .navigationTitle("Search location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationViewBody: View {
    
    @State private var text = ""
    @State private var locationsArray = [Location]()
    
    private let backgroundColor = Color(red: 239/255, green: 243/255, blue: 244/255)
    private let dataFetcher: DataFetcher = NetworkDataFetcher()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter city name", text: $text)
                    .padding()
                    .onChange(of: text) { text in
                        dataFetcher.getLocation(city: text) { locations, error in
                            if let error = error {
                                print("ERROR: \(error.localizedDescription)")
                                return
                            }
                            guard let locations = locations else {
                                return
                            }
                            self.locationsArray = locations
                        }
                    }
            }
            .background(backgroundColor)
            .cornerRadius(10)
            .padding()

            List {
                ForEach(locationsArray) { location in
                    ZStack {
                        if let state = location.state {
                            Text("\(location.localNames?.ru ?? location.name), \(state), \(location.country)")
                        } else {
                            Text("\(location.localNames?.ru ?? location.name), \(location.country)")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UserDefaults.standard.saveLocation(location) {
                            dismiss()
                        }
                    }
                }
            }.listStyle(.plain)
        }
    }
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
