//
//  DegreesFormater.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/16/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class DegreesFormater {
    
    init(fahrenheit: Double) {
        self.fahrenheit = fahrenheit
    }
    
    private var fahrenheit: Double
    
    var celsiFormat: String {
        return prepareDegreeLabel(from: fahrenheit)
    }
    
    private func prepareDegreeLabel(from: Double) -> String {
        let celsi = convertToCelsius(fahrenheit: Int(from))
        return celsi >= 0 ? "+\(celsi)℃" : "\(celsi)℃"
    }
    
    private func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}
