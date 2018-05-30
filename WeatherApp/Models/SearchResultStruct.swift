//
//  SearchResultStruct.swift
//  WeatherApp
//
//  Created by Oleksii Kolomiiets on 5/25/18.
//  Copyright © 2018 Oleksii Kolomiiets. All rights reserved.
//

import Foundation
import MapKit

struct SearchResultData {
    var city: String
    var address: String?
    
    init(_ data: MKMapItem) {
        
        self.city = data.placemark.name ?? ""
        self.address = AddressManager(data.placemark)?.resultString
    } 
}
