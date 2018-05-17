//
//  WeatherSearchManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

struct LongTimeWeather: WeatherProtocol {
    let time: Int
    let temperature: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let time = json["time"] as? Int else {throw SerializationError.missing("time is missing")}

        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.time = time
        self.temperature = temperature
        
    }
}
