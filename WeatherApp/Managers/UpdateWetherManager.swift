//
//  UpdateWetherManager.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/21/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation

class UpdateWetherManager {
    
    var delegate: MainViewController?
    var location: String? {
        didSet {
            guard let location = self.location else { return }
            updateWeatherForLocation(location: location)
        }
    }
    
    private func updateWeatherForLocation (location:String) {
        guard let strongDelegate = delegate else { return }
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil, let locality = placemarks?.first?.locality {
                strongDelegate.cityNameLabel.text = locality
                if let location = placemarks?.first?.location {
                    self.getDataFromApi(coordinate: location.coordinate)
                }
            }
        }
    }
    
    private func getDataFromApi(coordinate: CLLocationCoordinate2D) {
        guard let strongDelegate = delegate else { return }
        WeatherManager.forecast(withLocation: coordinate, completion: { (dayliForecast:[WeatherData]?, currentlyForecast: WeatherData?, hourlyForecast: [WeatherData]?) in
            if let dayliForecastData = dayliForecast, let currentlyForecastData = currentlyForecast, let hourlyForecastData = hourlyForecast, let formattedDate = CelsiusManager(fahrenheit: currentlyForecastData.temperature)?.resultString {                
                DispatchQueue.main.async {                    
                    strongDelegate.weeklyForecastTableViewController?.forecastData = dayliForecastData
                    strongDelegate.hourlyForecastData = hourlyForecastData
                    strongDelegate.updateUI(currentDegree: formattedDate)
                }
            }
        })
    }
}
