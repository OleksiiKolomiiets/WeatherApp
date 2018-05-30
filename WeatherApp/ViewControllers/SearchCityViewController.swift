//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/24/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SearchCityViewController: UIViewController, UISearchBarDelegate {

    var delegate: WeatherPagesViewController?
    var embededTableViewController: SearchResultTableViewController?
    @IBOutlet weak var searchBar: UISearchBar!
 
    @IBAction func tappedCancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func backToRoot(with searchResults: String) {
        guard let strongDelegate = delegate else { return }
        strongDelegate.cityManager.addCity(searchResults)
        strongDelegate.orderdViewControllers.append(strongDelegate.orderdViewControllers.last!)
        strongDelegate.setViewControllers([strongDelegate.orderdViewControllers.last!], direction: .forward, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResultsForSearchController(searchBarText: searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self        
        searchBar.becomeFirstResponder()
        guard let embededVC = self.embededTableViewController else { return }
        embededVC.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seachResultIdentifier",
            let embededVC = segue.destination as? SearchResultTableViewController  {
            embededTableViewController = embededVC
        }
    }
    
    func updateSearchResultsForSearchController(searchBarText: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response, let embededVC = self.embededTableViewController else { return  }
            embededVC.dataForCell = response.mapItems
            embededVC.tableView.reloadData()
        }
    }
}
