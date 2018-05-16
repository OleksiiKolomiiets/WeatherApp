//
//  WeatherSearchManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
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
    
    static let apiKey = "eceac25e196ca1898edfbfeded3dec64"
    static let basePath = "https://api.darksky.net/forecast/\(apiKey)/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?, [CurrentWeather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var dailyForecast:[Weather] = []
            var currentForecast:[CurrentWeather] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                        let dailyForecasts = json["daily"] as? [String:Any],
                        let dailyData = dailyForecasts["data"] as? [[String:Any]],
                        let currentForecasts = json["currently"] as? [String:Any] {
                        for dataPoint in dailyData {
                            if let weatherObject = try? Weather(json: dataPoint) {
                                dailyForecast.append(weatherObject)
                            }
                        }
                        if let weatherObject = try? CurrentWeather(json: currentForecasts) {
                            currentForecast.append(weatherObject)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(dailyForecast, currentForecast)
            }
        }
        task.resume()
    }
}

struct CurrentWeather {
    let time: Int
    let temperature: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let time = json["time"] as? Int else {throw SerializationError.missing("time is missing")}
        
        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temperature is missing")}
        
        self.time = time
        self.temperature = temperature
        
    }
}

