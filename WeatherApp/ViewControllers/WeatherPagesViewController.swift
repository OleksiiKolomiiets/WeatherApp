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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderdViewControllers.index(of: viewController) else { return nil }
        let prevIndex = viewControllerIndex - 1
        guard prevIndex >= 0, orderdViewControllers.count > prevIndex else { return nil }
        return orderdViewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderdViewControllers.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard orderdViewControllers.count != nextIndex, orderdViewControllers.count > nextIndex else { return nil }
        return orderdViewControllers[nextIndex]
    }
    
    @IBAction func tappedAddCityButton(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVCIdentifier") as? SearchCityViewController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var orderdViewControllers: [UIViewController] = {
        var pages = [self.getViewController(withLocationString: nil)]
        
        for city in cityManager.cities {
            pages.append(self.getViewController(withLocationString: city))
        }
        return pages
    }()
    
    func addPages() -> [UIViewController] {
        let data = self.cityManager
        if cityManager.isStarting || cityManager.wasCityAdd {
            cityManager.isStarting = false
            cityManager.prevCountOfCities = cityManager.cityCount
            for index in 0..<data.cityCount {
                orderdViewControllers.append(self.getViewController(withLocationString: data.cities[index]))
            }
        }
        return orderdViewControllers
    }
    
    fileprivate func getViewController(withLocationString locationString: String?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: IDENTIFIER)
        guard let weatherViewController = viewController as? MainViewController else { return viewController }
        weatherViewController.pageViewController = self
        weatherViewController.cityPageName = locationString
        return weatherViewController
    }
    
    var cityManager = CityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = orderdViewControllers.first {
            setViewControllers([firstVC], direction: .reverse, animated: true, completion: nil)
        }
    }
}
