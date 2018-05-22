//
//  CityManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/21/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class CityManager {
    var cities = [String]()
    var cityCount: Int {
        return self.cities.count
    }
    var last: String {
        return self.cities[cities.count]
    }
    
    func isNotDuplicatedCity(_ newCity: String) -> Bool {
        for city in self.cities {
            if city == newCity {
                return false
            }
        }
        return true
    }
    
    func addCity(_ city: String) {
        if isNotDuplicatedCity(city) {
            self.cities.append(city)
            
        }
    }
    
    
    
    
    func printCities() {
        print(self.cities)
    }
}
