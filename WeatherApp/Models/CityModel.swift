//
//  CityManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/21/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class CityModel {
//    var cities: [String?] = [nil]
    var cities: Set<String?> = [nil]
    var cityCount: Int {
        return self.cities.count
    }
    var prevCountOfCities: Int = 0
    
    var isStarting = true
    var wasCityAdd: Bool {
        return prevCountOfCities < cityCount
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
            self.cities.insert(city)
            print(self.cities)
        }
    }

//    func addCurretnLocationCity(_ city: String) {
//        if isNotDuplicatedCity(city) {
//            self.cities[0] = city
//            print(self.cities)
//        }
//    }
}

extension Optional: Hashable where Wrapped: Hashable {
    public var hashValue: Int {
        return self?.hashValue ?? 0
    }
}
