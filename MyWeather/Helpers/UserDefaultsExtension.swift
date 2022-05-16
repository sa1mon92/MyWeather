//
//  UserDefaultsExtension.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 16.05.2022.
//

import Foundation

extension UserDefaults {
    
    static let savedLocationKey = "savedLocationKey"
    
    func saveLocation(_ location: Location, completion: @escaping () -> Void) {
        
        let defaults = UserDefaults.standard
        
        let localNames = SavedLocation.SavedLocalNames(en: location.localNames?.en, ru: location.localNames?.ru)
        let savedLocation = SavedLocation(name: location.name, localNames: localNames, lat: location.lat, lon: location.lon, country: location.country, state: location.state)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: savedLocation, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: UserDefaults.savedLocationKey)
            completion()
        }
    }
}
