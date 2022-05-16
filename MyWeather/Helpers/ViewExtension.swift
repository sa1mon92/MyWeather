//
//  ViewExtension.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 14.05.2022.
//

import SwiftUI

extension View {
    
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}
