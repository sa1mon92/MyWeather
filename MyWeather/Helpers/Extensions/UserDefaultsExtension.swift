//
//  UserDefaultsExtension.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 16.05.2022.
//

import Foundation

extension UserDefaults {
    
    static let savedLocationKey = "savedLocationKey"
    @objc dynamic var savedLocationWrappedValue: Any? {
        get {
            return object(forKey: UserDefaults.savedLocationKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.savedLocationKey)
        }
    }
    
    func saveLocation(_ location: Location, completion: @escaping () -> Void) {
        let localNames = SavedLocation.SavedLocalNames(en: location.localNames?.en, ru: location.localNames?.ru)
        let savedLocation = SavedLocation(name: location.name, localNames: localNames, lat: location.lat, lon: location.lon, country: location.country, state: location.state)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: savedLocation, requiringSecureCoding: false) {
            savedLocationWrappedValue = savedData
            completion()
        }
    }
    
    func savedLocation() -> Location? {
        guard let data = savedLocationWrappedValue as? Data else { return nil }
        return Location(from: data)
    }
}
