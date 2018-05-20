//
//  DayliForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/16/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class DayliForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourLable: UILabel!
    @IBOutlet weak var hourTemperatureLable: UILabel!
}

extension DayliForecastCollectionViewCell: ConfigurableCellProtocol {
    func configure(with structure: WeatherProtocol) {
        let dateFormater = DisplayDateFormatter(date: structure.time, datePattern: .hours)
        self.hourLable.text = dateFormater.resultString
        
        let degreesFormater = CelsiusFormater(fahrenheit: structure.temperature)
        self.hourTemperatureLable.text = degreesFormater.resultString
    }
}
