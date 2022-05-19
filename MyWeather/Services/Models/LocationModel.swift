//
//  LocationModel.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import Foundation

// MARK: - Location
struct Location: Codable, Identifiable {
    
    let id = UUID()
    
    let name: String
    let localNames: LocalNames?
    let lat, lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let en, ru: String?

    enum CodingKeys: String, CodingKey {
        case en, ru
    }
}

class SavedLocation: NSObject, NSCoding {

    let name: String
    let localNames: SavedLocalNames?
    let lat, lon: Double
    let country: String
    let state: String?
    
    @objc(_TtCC9MyWeather13SavedLocation15SavedLocalNames)class SavedLocalNames: NSObject, NSCoding  {
        
        let en, ru: String?
        
        init(en: String?, ru: String?) {
            self.en = en
            self.ru = ru
        }
        
        required init?(coder: NSCoder) {
            en = coder.decodeObject(forKey: "en") as? String
            ru = coder.decodeObject(forKey: "ru") as? String
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(en, forKey: "en")
            coder.encode(ru, forKey: "ru")
        }
    }
    
    init(name: String, localNames: SavedLocalNames?, lat: Double, lon: Double, country: String, state: String?) {
        self.name = name
        self.localNames = localNames
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
        
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        localNames = coder.decodeObject(forKey: "localNames") as? SavedLocalNames
        lat = coder.decodeDouble(forKey: "lat") as Double
        lon = coder.decodeDouble(forKey: "lon") as Double
        country = coder.decodeObject(forKey: "country") as? String ?? ""
        state = coder.decodeObject(forKey: "state") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(localNames, forKey: "localNames")
        coder.encode(lat, forKey: "lat")
        coder.encode(lon, forKey: "lon")
        coder.encode(country, forKey: "country")
        coder.encode(state, forKey: "state")
    }
}



