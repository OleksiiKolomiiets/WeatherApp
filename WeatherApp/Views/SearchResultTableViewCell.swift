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
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        self.cityLabel.text = data.address
        self.addressLabel.text = data.address
    }
}
