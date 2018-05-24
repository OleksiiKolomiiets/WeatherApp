//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/24/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController, UISearchBarDelegate {

    var delegate: WeatherPagesViewController?
    @IBOutlet weak var searchBar: UISearchBar!
 
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            guard let strongDelegate = delegate, let lastViewController = strongDelegate.orderdViewControllers.last else { return }
            strongDelegate.cityManager.addCity(locationString)
            strongDelegate.orderdViewControllers = strongDelegate.addPages()
            print(strongDelegate.cityManager.cities)
            strongDelegate.setViewControllers([strongDelegate.orderdViewControllers.last!], direction: .forward, animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
