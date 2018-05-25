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

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    @IBOutlet weak var longitudeLable: UILabel!
    @IBOutlet weak var latitudeLable: UILabel!
    
}

extension SearchResultTableViewCell {
    func configure(with data: SearchResultData) {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)        
        self.titleLable.text = data.city
        self.subtitleLable.text = data.country
        self.longitudeLable.text = String(data.longitude)
        self.latitudeLable.text =  String(data.latitude)
    }
}
