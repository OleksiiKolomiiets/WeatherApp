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
    var hourlyForecastData = [WeatherData]() {
        didSet { 
            containerViewForCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    var cityPageName: String? 
    var cityName: String = "" {
        didSet {
            self.cityNameLabel.text = self.cityName
        }
    }
    var pageTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print(self.cityPageName ?? "nil")
        if self.cityPageName == nil {
            self.lookUpCurrentLocation { (placemark) in
                guard let locality: String = placemark?.locality else { return }
                self.cityName = locality
                self.updateWeatherForLocation(location: locality)
            }
        } else {           
            self.updateWeatherForLocation(location: self.cityPageName!)
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil, let locality = placemarks?.first?.locality {
                self.cityNameLabel.text = locality
                self.pageTitles.append(locality)
                print(self.pageTitles)
                if let location = placemarks?.first?.location {
                    self.getDataFromApi(coordinate: location.coordinate)
                }
            }
        }
    }
    
    func getDataFromApi(coordinate: CLLocationCoordinate2D) {
        WeatherManager.forecast(withLocation: coordinate, completion: { (dayliForecast:[WeatherData]?, currentlyForecast: WeatherData?, hourlyForecast: [WeatherData]?) in
            if let dayliForecastData = dayliForecast, let currentlyForecastData = currentlyForecast, let hourlyForecastData = hourlyForecast {
                let degreesFormater = CelsiusFormater(fahrenheit: currentlyForecastData.temperature)
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
            layer.borderColor = newValue?.cgColor
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
