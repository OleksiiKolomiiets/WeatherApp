//
//  CityEntity.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 7/26/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

struct CityEntity {
    let id: Int
    let name: String
    
    init(with dictionary: [String: Any]) {
        self.id = dictionary[TableField.id.rawValue] as! Int
        self.name = dictionary[TableField.name.rawValue] as! String
    }
    
    var dictionary: [String : Any] {
        return [
            TableField.id.rawValue : id,
            TableField.name.rawValue : name
        ]
    }
}
