//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesValueLabel: UILabel!
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    var updateWetherManager = UpdateWetherManager()
    var pageViewController: WeatherPagesViewController?
    var weeklyForecastTableViewController: WeeklyForecastTableViewController?
    var weeklyForecastData = [WeatherData]()
    var hourlyForecastData = [WeatherData]() {
        didSet {
            containerViewForCollectionView.reloadData()
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
        locationUpdate()
    }
    
    func locationUpdate() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        if self.cityPageName == nil {
//            self.lookUpCurrentLocation { (placemark) in
//                guard let locality: String = placemark?.locality else { return }
//                self.cityName = locality
//                self.updateWetherManager.location = locality
//                self.pageViewController?.cityManager.addCity(locality)
//            }
//        } else {
//            self.updateWetherManager.location =  self.cityPageName!
//        }
        if let cityPageName = self.cityPageName {
            self.updateWetherManager.location =  cityPageName
                
        }
        self.containerViewForCollectionView.reloadData()
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            print("authorized")
            manager.startUpdatingLocation()
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
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
    
    func updateUI(currentDegree: String) {
        self.degreesValueLabel.text = currentDegree
        self.view.layoutIfNeeded()
        self.weeklyForecastTableViewController?.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weekForecast" {
            let embededController = segue.destination
            self.weeklyForecastTableViewController = embededController as? WeeklyForecastTableViewController
            self.weeklyForecastTableViewController?.delegate = self            
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
