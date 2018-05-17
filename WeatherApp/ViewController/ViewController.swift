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
    
    var weeklyForecastTableViewController: WeeklyForecastTableViewController?
    var dayliForecastCollectionViewController: DayliForecastCollectionViewController?
    var hourlyForecastData = [ShortTimeWeather]() {
        didSet {
            containerViewForCollectionView.reloadData()
        }
    }
    var numberOfItemsInSection = 0
    
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
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?, currently: ShortTimeWeather?, hourlyForecast: [ShortTimeWeather]?) in
                        if let weatherData = results, let currentlyWeather = currently, let hourly = hourlyForecast {
                            let degreesFormater = DegreesFormater(fahrenheit: currentlyWeather.temperature)
                            self.weeklyForecastTableViewController?.forecastData = weatherData
                            DispatchQueue.main.async {
                                self.hourlyForecastData = hourly
                                self.degreesValueLabel.text = degreesFormater.celsiFormat
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
        if let identifier = segue.identifier, let segueIndetifier = SegueIndetifier(rawValue: identifier) {
            let embededController = segue.destination
            switch segueIndetifier {
            case .dayliForecast:
                self.dayliForecastCollectionViewController = embededController as? DayliForecastCollectionViewController
            case .weekForecast:
                self.weeklyForecastTableViewController = embededController as? WeeklyForecastTableViewController
            }
        }
    } 
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
}

enum SegueIndetifier: String {
    case dayliForecast, weekForecast
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyForecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCustom", for: indexPath)
        guard let coustumCell = cell as? DayliForecastCollectionViewCell else { return cell }
//        cell.configureWith(temp: arrayTempHourly[indexPath.row], time: arrayTimeHourly[indexPath.row])
        coustumCell.hourLable.text = dateFormater(for: hourlyForecastData[indexPath.row].time)
        let degreesFormater = DegreesFormater(fahrenheit: hourlyForecastData[indexPath.row].temperature)
        coustumCell.hourTemperatureLable.text = degreesFormater.celsiFormat
        return coustumCell
    }
    
    private func dateFormater(for date: Int) -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(date))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: time)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "HH"
        guard let date: Date = yourDate else { return "Date error."}
        let myStringafd = formatter.string(from: date)
        return myStringafd
    }
}
