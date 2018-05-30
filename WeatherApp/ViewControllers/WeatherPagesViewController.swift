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
    var cityManager = CityModel()
    let pages = PagesManager()
    
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
        let weatherVC = self
        return cityManager.cities.map({ weatherVC.getViewController(withLocationString: $0) })
    }()
    
    fileprivate func getViewController(withLocationString locationString: String?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: IDENTIFIER)
        guard let weatherViewController = viewController as? MainViewController else { return viewController as! MainViewController }
        weatherViewController.pageViewController = self
        weatherViewController.cityPageName = locationString
        return weatherViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = orderdViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.dataSource = nil;
//        self.dataSource = self;
//    }
}
