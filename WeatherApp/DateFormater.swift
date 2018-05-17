//
//  DateFormater.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/17/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class DateFormatеer: FormatterProtocol {
    var resultString: String {
        return ""
    }
    private var datePattern: String
    private let defaultPattern = "yyyy-MM-dd HH:mm:ss"
    
    init(datePattern: String) {
        self.datePattern = datePattern
    }
    
    private func dateFormater(for date: Int, pattern: String) -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(date))
        let formatter = DateFormatter()
        formatter.dateFormat = defaultPattern
        let myString = formatter.string(from: time)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = pattern
        guard let date: Date = yourDate else { return "Date error."}
        let myStringafd = formatter.string(from: date)
        return myStringafd
    }
}
