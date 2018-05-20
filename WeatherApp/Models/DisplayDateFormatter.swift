//
//  DateFormater.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/17/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation

class DisplayDateFormatter: FormatterProtocol {
    var resultString: String {
        return dateFormatter(for: self.date, pattern: self.datePattern)
    }
    private var datePattern: DatePattern
    private var date: Int
    
    init(date: Int, datePattern: DatePattern) {
        self.date = date
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
    
    private func dateFormatter(for date: Int, pattern: DatePattern) -> String {
        let neededDate = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DatePattern.buDefault.value
        
        let neededDateString = dateFormatter.string(from: neededDate)
        let neededDateByPattern = dateFormatter.date(from: neededDateString)
        dateFormatter.dateFormat = pattern.value
        
        guard let date: Date = neededDateByPattern else { return "Date error."}
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}


