//
//  WeatherPagesViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/18/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class WeatherPagesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let IDENTIFIER = "WeatherPage"
    var clearPageLabel: UILabel?
    var locationCity: String?
    var cityManager = CityModel()
    var orderdViewControllers: [String?]  {
        return cityManager.getPages()
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
        let firstVC = self.getViewController(withLocationString: orderdViewControllers[1])
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
}
