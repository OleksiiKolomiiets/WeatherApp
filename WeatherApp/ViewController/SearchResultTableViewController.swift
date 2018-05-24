//
//  SearchResultTableViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/24/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    var dataForCell: [String] = []
    
    var countOfRow: Int {
        return dataForCell.count
    }
    private func getDataForCell(by index: Int) -> String {        
        return dataForCell[index]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfRow
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        cell.textLabel?.text = dataForCell[indexPath.row]
        return cell
    }
}
