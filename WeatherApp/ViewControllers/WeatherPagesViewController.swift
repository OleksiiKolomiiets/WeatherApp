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
    var cityManager = CityModel()
    var orderdViewControllers: [String?] {
        return cityManager.getPages(using: nil)
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
        clearPageLabel?.isHidden = true
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVCIdentifier") as? SearchCityViewController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getViewController(withLocationString locationString: String?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: IDENTIFIER)
        guard let weatherViewController = viewController as? MainViewController else { return viewController as! MainViewController }
        weatherViewController.pageViewController = self
        weatherViewController.cityPageName = locationString
        return weatherViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderdViewControllers)
        self.delegate = self
        self.dataSource = self
        if let city = orderdViewControllers[1]  {
            let firstVC = self.getViewController(withLocationString: city)
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        } else {
            setLableForClearPage()
        }
    }
    
    private func setLableForClearPage() {
        clearPageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        clearPageLabel?.center = CGPoint(x: 160, y: 285)
        clearPageLabel?.numberOfLines = 0
        clearPageLabel?.textAlignment = .center
        clearPageLabel?.text = "Please tap the button \nAdd City\n to see forecast.\n⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎\n⬇︎⬇︎⬇︎⬇︎⬇︎\n⬇︎⬇︎⬇︎\n⬇︎"
        clearPageLabel?.textColor = .white
        self.view.addSubview(clearPageLabel!)
    }
}
