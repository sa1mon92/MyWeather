//
//  AlertProvider.swift
//  MyWeather
//
//  Created by Дмитрий Садырев on 20.06.2022.
//

import SwiftUI

class AlertProvider {
    struct Alert {
        let title: String
        let message: String
        let primaryButtonText: String
        let primaryButtonAction: () -> Void
        let secondaryButtonText: String
        let secondaryButtonAction: () -> Void
    }

    var alert: Alert? = nil
}

extension Alert {
    init(_ alert: AlertProvider.Alert) {
        self.init(title: Text(alert.title),
                  message: Text(alert.message),
                  primaryButton: .default(Text(alert.primaryButtonText),
                                          action: alert.primaryButtonAction),
                  secondaryButton: .default(Text(alert.secondaryButtonText),
                                            action: alert.secondaryButtonAction))
    }
    
}
