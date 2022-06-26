//
//  ViewOffsetKey.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 25.06.2022.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
