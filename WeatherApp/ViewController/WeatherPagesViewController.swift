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
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        
        print("previos")
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? MainViewController, let viewControllerIndex = pages.index(of: controller) else { print(1); return nil }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else  { return nil }
        guard pages.count > nextIndex else { return nil }
        
        print("next")
        return pages[nextIndex]
    }
    
    
    var pageControl = UIPageControl()
   
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers else { return }
        self.pageControl.currentPage = pages.index(of: pageContentViewController[0])!
    }
    
    var pagesF = [UIViewController]()
    var pages: [UIViewController] {
        addPages(to: pagesF, data:cityManager)
        return  pagesF
    }
    
    func addPages(to array: [UIViewController], data: CityManager) {
        let start = array.count
        if data.cityCount > start {
            for index in start..<data.cityCount {
                self.pagesF.append(self.getViewController(withLocationString: data.cities[index]))
            }
        }
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
        pagesF.append(self.getViewController(withLocationString: nil))
        self.delegate = self
        self.dataSource = self
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pages.first, let firstViewControllerIndex = pages.index(of: firstViewController) else { return 0 }
        return firstViewControllerIndex
    }
}

enum PageType {
    case currentCity
    case addedCity(String)
}


