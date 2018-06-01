//
//  CityManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/21/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class CityModel {
    
    var cities: [String?] = []
    
    func getPreviousPage(using current: String?) -> String? {
        guard let indexOfCurrentPage: Int = cities.index(of: current) else { return nil }
        if indexOfCurrentPage == 0 {
            return nil
        }
        return cities[indexOfCurrentPage - 1]
    }
    func getNextPage(using current: String?) -> String? {
        guard let indexOfCurrentPage: Int = cities.index(of: current) else { return nil }
        if indexOfCurrentPage == cities.count - 1 {
            return nil
        }
        return cities[indexOfCurrentPage + 1]
    }
    
    func addCity(_ city: String) {
        if !cities.contains(city) { self.cities.append(city) }
        print(self.cities)
    }
    
    func getPages(using current: String?) -> [String?] {
        var previous: String?
        let current = current
        var next: String?
        var isFoundThePage = false
        var isSearchForCity = true
        cities.forEach {
            if let strongArgument = $0, isSearchForCity {
                if current == strongArgument {
                    isFoundThePage = true
                } else if isFoundThePage {                    
                    isSearchForCity = false
                    next = $0
                } else {
                    previous = $0
                }
            }
        }
        return [previous, current, next]
    }
}

