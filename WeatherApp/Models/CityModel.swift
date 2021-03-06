//
//  CityManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/21/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class CityModel {
        
    var cities: [String] = ["Vinnitsa", "Kiev"] {
        didSet {
            for index in 0 ..< cities.count {
                let cityName: String = self.cities[index]
                let city = CityEntity(with: [TableField.id.rawValue : index,TableField.name.rawValue : cityName])
                FirebaseService.addCity(city: city) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getPreviousPage(using current: String) -> String? {
        guard let indexOfCurrentPage: Int = cities.index(of: current) else { return nil }
        if indexOfCurrentPage == 0 {
            return nil
        }
        return cities[indexOfCurrentPage - 1]
    }
    
    func getNextPage(using current: String) -> String? {
        guard let indexOfCurrentPage: Int = cities.index(of: current) else { return nil }
        if indexOfCurrentPage == cities.count - 1 {
            return nil
        }
        return cities[indexOfCurrentPage + 1]
    }
    
    func addCity(_ city: String) {
        if !self.cities.contains(city) {
            self.cities.append(city)
        }
    }
    
    func getPages() -> [String?] {
        let startCitiesCount = 2
        var previous: String?
        var current: String?
        var next: String?
        if cities.count == startCitiesCount {
            current = cities[0]
            next = cities[1]
        } else {
            var isFoundThePage = false
            var isSearchForCity = true
            cities.forEach {
                if isSearchForCity {
                    if current == $0 {
                        isFoundThePage = true
                    } else if isFoundThePage {
                        isSearchForCity = false
                        next = $0
                    } else {
                        previous = $0
                    }
                }
            }
        }
        return [previous, current, next]
    }
}

