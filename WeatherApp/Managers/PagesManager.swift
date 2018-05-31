//
//  File.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/29/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class PagesManager {
   
    enum PageType {
        case previous(UIViewController)
        case current(UIViewController)
        case next(UIViewController)
    }
    
    let IDENTIFIER = "WeatherPage"
    var cityManager = CityModel()    
    lazy var orderdViewControllers: [UIViewController] = {
        return updatePagesIfNeeded(from: cityManager)
    }()
    var previousNumberOfCities = 0
    private func updatePagesIfNeeded(from model: CityModel) -> [UIViewController] {
        let pagesManager = self
        previousNumberOfCities = cityManager.cityCount
        return model.cities.map({ pagesManager.getViewController(withLocationString: $0) })
    }
    
    
    
//    func addPages() -> [UIViewController] {
//        let weatherVC = self
////        let array = cityManager.cities.map({ weatherVC.getViewController(withLocationString: $0) })
//        return array
//    }
    
    fileprivate func getViewController(withLocationString locationString: String?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: IDENTIFIER)
        guard let weatherViewController = viewController as? MainViewController else { return viewController as! MainViewController }
//        weatherViewController.pageViewController = self
        weatherViewController.cityPageName = locationString
        return weatherViewController
    }
}
