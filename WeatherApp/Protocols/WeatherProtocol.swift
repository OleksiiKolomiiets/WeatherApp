//
//  WeatherProtocol.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/17/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

protocol WeatherProtocol {
    var time: Int { get }
    var timeZone: TimeZone { get }
    var temperature: Double { get }
    var isShortTimeWeather: Bool { get set }
}
