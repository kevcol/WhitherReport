//
//  Weather.swift
//  WhitherReport
//
//  Created by Kevin Colligan on 5/12/16.
//  Copyright © 2016 KevCol Labs LLC. All rights reserved.
//

import Foundation

struct Weather {
    
    let cityName: String
    let temp: Double
    let description: String
    let icon: String
    let lon: Double
    let lat: Double
    
    init(cityName: String, temp: Double, description: String, icon: String, lon: Double, lat: Double) {
        self.cityName = cityName
        self.temp = temp
        self.description = description
        self.icon = icon
        self.lon = lon
        self.lat = lat
        
    }
    
    var tempC: Double {
        get {
            return temp - 273.15
        }
    }
    
    var tempF: Double {
        get {
            return tempC * 9/5 + 32
        }
    }
    
    
    
    
}
