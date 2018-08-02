//
//  DateFormater.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/17/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class DateFormatter: FormatterProtocol {
    var resultString: String {
        return dateFormatter(for: self.date, timeZone: self.timeZone, pattern: self.datePattern)
    }
    private var datePattern: DatePattern
    private var date: Int
    private var timeZone: TimeZone
    
    init(date: Int, datePattern: DatePattern, timeZone: TimeZone) {
        self.date = date
        self.timeZone = timeZone
        self.datePattern = datePattern
    }
    
    enum DatePattern {
        case buDefault
        case hours
        case date
        
        var value: String {
            switch self {
            case .buDefault:
                return "yyyy-MM-dd HH:mm:ss"
            case .hours:
                return "HH"
            case .date:
                return "dd-MMM-yyyy"
            }
        }
    }
    
    private func dateFormatter(for date: Int, timeZone: TimeZone, pattern: DatePattern) -> String {
        let neededDate = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DatePattern.buDefault.value
        dateFormatter.timeZone = timeZone
        
        let neededDateString = dateFormatter.string(from: neededDate)
        let neededDateByPattern = dateFormatter.date(from: neededDateString)
        dateFormatter.dateFormat = pattern.value
        
        guard let date: Date = neededDateByPattern else { return "Date error."}
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}


