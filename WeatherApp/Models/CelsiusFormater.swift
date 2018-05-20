//
//  DegreesFormater.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/16/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class CelsiusFormater: FormatterProtocol {
    
    var resultString: String {
        return self.celsiusPattern.string
    }
    
    init(fahrenheit: Double) {
        self.fahrenheit = fahrenheit
    }
    
    private var fahrenheit: Double
    private var celsius: Int {
        return convertToCelsius(fahrenheit: self.fahrenheit)
    }
    private var celsiusPattern: CelsiusPattern {
        return getCelsiusPattern(value: self.celsius)
    }    
    
    private func convertToCelsius(fahrenheit: Double) -> Int {
        return Int(5.0 / 9.0 * (fahrenheit - 32.0))
    }
    
    private func getCelsiusPattern(value: Int) -> CelsiusPattern {
        return value < 0 ? CelsiusPattern.belowZero(value) : CelsiusPattern.aboveZer(value)
    }
    
    enum CelsiusPattern {
        
        case belowZero(Int)
        case aboveZer(Int)
        
        var flag: String { return "℃" }
        
        var sign: String {
            switch self {
            case .belowZero(_):
                return ""
            case .aboveZer(_):
                return "+"
            }
        }
        
        var string: String {
            switch self {
            case .belowZero(let value):
                return "\(self.sign)\(value)\(self.flag)"
            case .aboveZer(let value):
                return "\(self.sign)\(value)\(self.flag)"
            }
        }
    }
}
