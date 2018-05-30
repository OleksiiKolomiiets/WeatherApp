//
//  SearchResultTableViewCell.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/25/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit
import CoreLocation

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
}

extension SearchResultTableViewCell {
    func configure(with data: SearchResultData) {
        self.cityLabel.text = data.address
        self.addressLabel.text = data.address
    }
}
