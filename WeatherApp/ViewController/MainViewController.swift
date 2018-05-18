//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesValueLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
    
    var weeklyForecastTableViewController: WeeklyForecastTableViewController?
    var cityName = "Kiev"
    var hourlyForecastData = [ShortTimeWeather]() {
        didSet { 
            containerViewForCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cityNameLabel.text = self.cityName
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
                let locationString = placemarks?.first?.name
                if let location = placemarks?.first?.location {
                    
                    WeatherManager.forecast(withLocation: location.coordinate, completion: { (dayliForecast:[LongTimeWeather]?, currentlyForecast: ShortTimeWeather?, hourlyForecast: [ShortTimeWeather]?) in
                        if let dayliForecastData = dayliForecast, let currentlyForecastData = currentlyForecast, let hourlyForecastData = hourlyForecast {
                            let degreesFormater = DegreesFormater(fahrenheit: currentlyForecastData.temperature)
                            self.weeklyForecastTableViewController?.forecastData = dayliForecastData
                            DispatchQueue.main.async {
                                self.cityNameLabel.text = locationString
                                self.hourlyForecastData = hourlyForecastData
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {    
    
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
