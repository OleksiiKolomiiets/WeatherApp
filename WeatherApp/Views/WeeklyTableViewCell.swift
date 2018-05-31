//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/16/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {
   
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!

}

extension WeeklyTableViewCell: ConfigurableCellProtocol {
    func configure(with structure: WeatherProtocol) {        
        let temperatureFormater = CelsiusManager(fahrenheit: structure.temperature)
        self.temperatureLabel.text = temperatureFormater?.resultString
        
        let dateFormater = DateManager(date: structure.time, datePattern: .days, timeZone: structure.timeZone)
        self.forecastDescriptionLabel.text = dateFormater?.resultString
    }
}
