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

class MainViewController: UIViewController, CLLocationManagerDelegate {
     
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesValueLabel: UILabel!
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    let updateWetherManager = UpdateWetherManager()
    var pageViewController: WeatherPagesViewController?
    var weeklyForecastTableViewController: WeeklyForecastTableViewController?
    var searchedCity: String = ""
//    var isSearchBarShowing = false {
//        didSet {
//            searchBar.becomeFirstResponder()
//            if !isSearchBarShowing {
//                searchBar.resignFirstResponder()
//            }
//            searchBar.isHidden.toggle()
//        }
//    }
   
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWetherManager.delegate = self
        locationUpdtae()         
    }
    
    private func locationUpdtae() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if self.cityPageName == nil {
            self.lookUpCurrentLocation { (placemark) in
                guard let locality: String = placemark?.locality else { return }
                self.cityName = locality
                self.updateWetherManager.location = locality
                self.pageViewController?.cityManager.addCity(locality)
            }
        } else {
            self.updateWetherManager.location =  self.cityPageName!
        }
    }
    
    private func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            CLGeocoder().reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
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

extension Bool {
    mutating func toggle() {
        self = !self
    }
}
