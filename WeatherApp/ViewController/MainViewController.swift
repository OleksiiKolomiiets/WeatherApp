//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesValueLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
    @IBOutlet weak var containerViewCollection: UIView!
    
    var weeklyForecastTableViewController: WeeklyForecastTableViewController?
    let locationManager = CLLocationManager()
    var cityName = "Kiev" // TODO: geolocation city
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
        
        containerViewForCollectionView.backgroundColor = .clear
        updateWeatherForLocation(location: cityNameLabel.text!)
        
        
        // get geocordinate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let geocordinate = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        cityName = "Lviv"
        
        
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
                self.cityNameLabel.text = placemarks?.first?.locality
                if let location = placemarks?.first?.location {
                    self.getDataFromApi(coordinate: location.coordinate)
                }
            }
        }
    }
    
    func getDataFromApi(coordinate: CLLocationCoordinate2D) {
        WeatherManager.forecast(withLocation: coordinate, completion: { (dayliForecast:[LongTimeWeather]?, currentlyForecast: ShortTimeWeather?, hourlyForecast: [ShortTimeWeather]?) in
            if let dayliForecastData = dayliForecast, let currentlyForecastData = currentlyForecast, let hourlyForecastData = hourlyForecast {
                let degreesFormater = DegreesFormater(fahrenheit: currentlyForecastData.temperature)
                self.weeklyForecastTableViewController?.forecastData = dayliForecastData
                DispatchQueue.main.async {
                    self.hourlyForecastData = hourlyForecastData
                    self.degreesValueLabel.text = degreesFormater.resultString
                    self.view.layoutIfNeeded()
                    self.weeklyForecastTableViewController?.tableView.reloadData()
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weekForecast" {
            let embededController = segue.destination
            self.weeklyForecastTableViewController = embededController as? WeeklyForecastTableViewController
        }
    }
    
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
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
