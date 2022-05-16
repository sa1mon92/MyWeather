//
//  LocationModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Foundation

// MARK: - Location
struct Location: Codable {
    let name: String
    let localNames: LocalNames
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let en, de, ru, featureName: String?

    enum CodingKeys: String, CodingKey {
        case en, ru, de
        case featureName = "feature_name"
    }
}
