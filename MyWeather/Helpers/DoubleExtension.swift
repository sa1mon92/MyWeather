//
//  DoubleExtension.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 18.05.2022.
//

import Foundation

extension Double {
    
    func convertToString() -> String {
        var newValue: Double
        if Int(self) == 0 {
            newValue = abs(self)
        } else {
            newValue = self
        }
        return String(format: "%.0f", newValue)
    }
}
