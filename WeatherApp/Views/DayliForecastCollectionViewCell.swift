//
//  DayliForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/16/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class DayliForecastCollectionViewCell: UICollectionViewCell {    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourTemperatureLabel: UILabel!
}

extension DayliForecastCollectionViewCell: ConfigurableCellProtocol {
    func configure(with structure: WeatherProtocol) {
        let dateFormater = DateManager(date: structure.time, datePattern: .hours, timeZone: structure.timeZone)
        self.hourLabel.text = dateFormater?.resultString
        
        let degreesFormater = CelsiusManager(fahrenheit: structure.temperature)
        self.hourTemperatureLabel.text = degreesFormater?.resultString
    }
}
