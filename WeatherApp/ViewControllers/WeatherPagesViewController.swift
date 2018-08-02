//
//  WeatherPagesViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/18/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherPagesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CLLocationManagerDelegate {
    
    let IDENTIFIER = "WeatherPage"
    var clearPageLabel: UILabel?
    var locationCity: String?
    var cityManager = CityModel()
    let locationManager = CLLocationManager()
    var orderdViewControllers: [String?]  {
        return cityManager.getPages(using: nil)
    }
    
    var cities: [String]? {
        didSet {
            
            self.view.layoutIfNeeded()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? MainViewController, let city = viewController.cityPageName else { return nil }
        let cityString = cityManager.getPreviousPage(using: city)
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        
        return cityString == nil ? nil : self.getViewController(withLocationString: cityString)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? MainViewController, let city = viewController.cityPageName else { return nil }
        let cityString = cityManager.getNextPage(using: city)
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        
        return cityString == nil ? nil : self.getViewController(withLocationString: cityString)
    }
    
    @IBAction func tappedAddCityButton(_ sender: UIButton) {        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVCIdentifier") as? SearchCityViewController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getViewController(withLocationString locationString: String?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: IDENTIFIER)
        guard let weatherViewController = viewController as? MainViewController else { return viewController }
        weatherViewController.pageViewController = self
        weatherViewController.cityPageName = locationString
        return weatherViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        cityManager.updatePages()
        FirebaseService.getAll { (cities, _) in
            var temporaryArray = [String]()
            cities.forEach() { temporaryArray.append($0.name) }
            self.cities = temporaryArray
            self.setPages()
            self.clearPageLabel?.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }
    
    private func setPages() {
        if let city = orderdViewControllers[1]  {
            self.clearPageLabel?.isHidden = true
            self.view.layoutIfNeeded()
            self.clearPageLabel?.isHidden = true
            let firstVC = self.getViewController(withLocationString: city)
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        } else {
            guard let currentLocation = tryToGetCurrentLocation(), let locationCity = locationCity else { setLableForClearPage(); return }
            cityManager.addCity(currentLocation)
            let addedPage = getViewController(withLocationString: locationCity)
            setViewControllers([addedPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func tryToGetCurrentLocation() -> String? {
        var result: String?
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.lookUpCurrentLocation { (placemark) in
            guard let locality = placemark?.locality else { return }
            result = locality
        }
        return result
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
    
    private func setLableForClearPage() {
        if clearPageLabel == nil {
            clearPageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            clearPageLabel?.center = CGPoint(x: 160, y: 285)
            clearPageLabel?.numberOfLines = 0
            clearPageLabel?.textAlignment = .center
            clearPageLabel?.text = "Please tap the \nAdd City\n button to see its forecast.\n⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎\n⬇︎⬇︎⬇︎⬇︎⬇︎\n⬇︎⬇︎⬇︎\n⬇︎"
            clearPageLabel?.textColor = .white
            if let clearPageLabel = clearPageLabel {
                self.view.addSubview(clearPageLabel)
                
                clearPageLabel.translatesAutoresizingMaskIntoConstraints = false
                clearPageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                clearPageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                clearPageLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
                clearPageLabel.heightAnchor.constraint(equalToConstant: 285).isActive = true
            }
        } else {
            clearPageLabel?.removeFromSuperview()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lookUpCurrentLocation { (placemark) in
            self.locationCity = placemark?.locality
            guard let locationCity = self.locationCity else { return }
            if self.cityManager.cities.count == 0 {
                self.cityManager.addCity(locationCity)
            } else {
                self.cityManager.cities[0] = locationCity
            }
            let addedPage = self.getViewController(withLocationString: self.locationCity)
            self.setViewControllers([addedPage], direction: .forward, animated: true, completion: nil)
            self.clearPageLabel?.isHidden = true
        }
        self.view.layoutIfNeeded()
    }
}
