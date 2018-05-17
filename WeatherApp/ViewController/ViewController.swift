//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesValueLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
    
    var weeklyForecastTableViewController: WeeklyForecastTableViewController?
    var hourlyForecastData = [ShortTimeWeather]() {
        didSet { 
            containerViewForCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cityNameLabel.text = "Kiev"
        updateWeatherForLocation(location: cityNameLabel.text!)
        containerViewForCollectionView.backgroundColor = .clear
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
        
    }
    
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    WeatherManager.forecast(withLocation: location.coordinate, completion: { (results:[LongTimeWeather]?, currently: ShortTimeWeather?, hourlyForecast: [ShortTimeWeather]?) in
                        if let weatherData = results, let currentlyWeather = currently, let hourly = hourlyForecast {
                            let degreesFormater = DegreesFormater(fahrenheit: currentlyWeather.temperature)
                            self.weeklyForecastTableViewController?.forecastData = weatherData
                            DispatchQueue.main.async {
                                self.hourlyForecastData = hourly
                                self.degreesValueLabel.text = degreesFormater.resultString
                                self.view.layoutIfNeeded()
                                self.weeklyForecastTableViewController?.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weekForecast" {
            let embededController = segue.destination
            self.weeklyForecastTableViewController = embededController as? WeeklyForecastTableViewController
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyForecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCustom", for: indexPath)
        guard let coustumCell = cell as? DayliForecastCollectionViewCell else { return cell }
        
        coustumCell.configure(with: hourlyForecastData[indexPath.row])
        
        return coustumCell
    }
}
