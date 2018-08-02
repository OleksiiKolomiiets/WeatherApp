//
//  FirebaseService.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 7/26/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirebaseService {
    
    static var cities = [CityEntity]()
    
    static func getAll(completion: @escaping ([CityEntity], Error?) -> Void) {
        Firestore.firestore().collection(TableName.city.rawValue).getDocuments { (querySnapshot, error) in
            var cities = [CityEntity]()
            var error: Error?
            querySnapshot?.documents.forEach() { cities.append(CityEntity(with: $0.data())) }
            self.cities = cities
            completion(cities, error)
        }
    }
    
    static func addCity(city: CityEntity, completion: @escaping (Error?) -> Void) {
        
        var error: Error?
        cities.forEach() {
            if $0.name == city.name { completion(error); return }
        }
        Firestore.firestore().collection(TableName.city.rawValue).document().setData(city.dictionary)
        completion(error)
    }
}
