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
    var country: String
    var latitude: Double
    var longitude: Double
    
    init(_ data: MKMapItem) {
        self.latitude = data.placemark.location?.coordinate.latitude ?? 0.00
        self.longitude = data.placemark.location?.coordinate.longitude ?? 0.00
        self.city = data.placemark.name ?? "City"
        self.country = data.placemark.country ?? "Country"
    }
}
