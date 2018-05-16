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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        updateWeatherForLocation(location: "Kiev")
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
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.weeklyForecastTableViewController?.forecastData = weatherData
                            DispatchQueue.main.async {
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
}

enum SegueIndetifier: String {
    case dayliForecast, weekForecast
    
    
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCustom", for: indexPath)
//        cell.configureWith(temp: arrayTempHourly[indexPath.row], time: arrayTimeHourly[indexPath.row])
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
    }
}
