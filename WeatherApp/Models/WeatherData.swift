//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/20/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

struct WeatherData: WeatherProtocol {
    var isShortTimeWeather: Bool
    let time: Int
    let temperature: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any], isShortTimeWeather:Bool) throws {
        self.isShortTimeWeather = isShortTimeWeather
        guard let time = json["time"] as? Int else {throw SerializationError.missing("time is missing")}
        guard let temperature = json[isShortTimeWeather ? "temperature" : "temperatureMax"] as? Double else {throw SerializationError.missing("temperature is missing")}
        self.time = time
        self.temperature = temperature
    }
}
