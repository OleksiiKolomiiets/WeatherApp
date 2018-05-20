//
//  WeatherPagesViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/18/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class WeatherPagesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    

    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "WeatherPage", locationString: nil),
            self.getViewController(withIdentifier: "WeatherPage", locationString: "Lviv")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String, locationString: String?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        guard let weatherViewController = viewController as? MainViewController else { return viewController }
        weatherViewController.cityPageName = locationString
        return weatherViewController
    }
    
    var controller: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}


