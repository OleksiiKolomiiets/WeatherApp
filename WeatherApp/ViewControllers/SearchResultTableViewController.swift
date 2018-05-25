//
//  SearchResultTableViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/24/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import MapKit

class SearchResultTableViewController: UITableViewController {
    
    var dataForCell: [MKMapItem] = []
    var delegate: SearchCityViewController?
    var countOfRow: Int {
        return dataForCell.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .clear
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfRow
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        let data = SearchResultData(dataForCell[indexPath.row])
        cell.configure(with: data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let strongDelegate = delegate, let selectedCityName = dataForCell[indexPath.row].name else { return }
        strongDelegate.backToRoot(with: selectedCityName)
    }
}
