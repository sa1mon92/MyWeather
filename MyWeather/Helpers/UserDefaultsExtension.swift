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
    
    func savedLocation() -> Location? {
        
        let defaults = UserDefaults.standard
        
        guard let savedLocation = defaults.object(forKey: UserDefaults.savedLocationKey) as? Data else { return nil }
        
        guard let decodedLocation = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedLocation) as? SavedLocation else { return nil }
        
        let localNames = LocalNames(en: decodedLocation.localNames?.en, ru: decodedLocation.localNames?.ru)
        let location = Location(name: decodedLocation.name, localNames: localNames, lat: decodedLocation.lat, lon: decodedLocation.lon, country: decodedLocation.country, state: decodedLocation.state)
                
        return location
    }
}
