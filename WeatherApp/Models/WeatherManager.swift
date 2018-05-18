//
//  WeatherForecastGetter.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/17/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherManager {
    static let apiKey = "eceac25e196ca1898edfbfeded3dec64"
    static let basePath = "https://api.darksky.net/forecast/\(apiKey)/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([LongTimeWeather]?, ShortTimeWeather?, [ShortTimeWeather]?) -> ()) {        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var dailyForecast:[LongTimeWeather] = []
            var currentForecast: ShortTimeWeather?
            var hourlyForecast: [ShortTimeWeather] = []
            let maximumAmountOfHourlyResults = 18
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                        let dailyForecasts = json["daily"] as? [String:Any],
                        let dailyData = dailyForecasts["data"] as? [[String:Any]],
                        let hourlyForecasts = json["hourly"] as? [String:Any],
                        let hourlyData = hourlyForecasts["data"] as? [[String:Any]],
                        let currentForecasts = json["currently"] as? [String:Any] {
                        for dataPoint in dailyData {
                            if let weatherObject = try? LongTimeWeather(json: dataPoint) {
                                dailyForecast.append(weatherObject)
                            }
                        }
                        var count = 0
                        for dataPoint in hourlyData {
                            if let weatherObject = try? ShortTimeWeather(json: dataPoint),
                                count <= maximumAmountOfHourlyResults {
                                hourlyForecast.append(weatherObject)
                                count += 1
                            }
                        }
                        if let weatherObject = try? ShortTimeWeather(json: currentForecasts) {
                            currentForecast = weatherObject
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(dailyForecast, currentForecast, hourlyForecast)
            }
        }
        task.resume()
    }
}
