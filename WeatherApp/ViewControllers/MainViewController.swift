//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesValueLabel: UILabel!
    @IBOutlet weak var containerViewForCollectionView: UICollectionView!
    
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
            self.view.layoutIfNeeded()
            self.cityNameLabel.text = self.cityName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWetherManager.delegate = self
        locationUpdate()
    }
    
    func locationUpdate() {
        if let cityPageName = self.cityPageName {
            self.updateWetherManager.location =  cityPageName
        }
        self.containerViewForCollectionView.reloadData()
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
