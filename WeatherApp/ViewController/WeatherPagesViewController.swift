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
        guard let viewControllerIndex = orderdViewControllers.index(of: viewController) else { print("Before 1"); return nil }
        let prevIndex = viewControllerIndex - 1
        guard prevIndex >= 0 else {
            print("Before 2")
            return nil
        }
        guard orderdViewControllers.count > prevIndex else {
            print("Before 3")
            return nil
        }
        return orderdViewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderdViewControllers.index(of: viewController) else { print("After 1"); return nil }
        let nextIndex = viewControllerIndex + 1
        guard orderdViewControllers.count != nextIndex else {
            print("After 2")
            return nil
        }
        guard orderdViewControllers.count > nextIndex else {
            print("After 3")
            return nil
        }
        return orderdViewControllers[nextIndex]
    }
    
    var pageControl = UIPageControl()
   
    @IBAction func tappedAddCityButton(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVCIdentifier") as? SearchCityViewController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return cityManager.cityCount
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    var pagesF = [UIViewController]()
    var pages: [UIViewController] {
        return addPages()
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
        guard let weatherViewController = viewController as? MainViewController else { print("viewController as? error"); return viewController }
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
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return pages.count
//    }
//
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        guard let firstViewController = pages.first, let firstViewControllerIndex = pages.index(of: firstViewController) else { return 0 }
//        return firstViewControllerIndex
//    }
}

enum PageType {
    case currentCity
    case addedCity(String)
}

enum PageController {
    case prev
    case current
    case next
}

