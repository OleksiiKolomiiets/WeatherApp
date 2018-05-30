//
//  DayliForecastTableViewController.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/15/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class WeeklyForecastTableViewController: UITableViewController {

    var forecastData = [WeatherData]()
    var delegate: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.costumRefreshControl)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyForecastCellIdentifier", for: indexPath) as? WeeklyTableViewCell else { return UITableViewCell() }
        cell.configure(with: self.forecastData[indexPath.row])
        tableView.separatorColor = .clear
        return cell
    }
    
    lazy var costumRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(WeeklyForecastTableViewController.handleRefresh(_:)),
            for: UIControlEvents.valueChanged
        )
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        delegate?.locationUpdate()
        refreshControl.endRefreshing()
    }
}
