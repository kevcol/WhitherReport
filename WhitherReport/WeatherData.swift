//
//  WeatherData.swift
//  WhitherReport
//
//  Created by Kevin Colligan on 5/12/16.
//  Copyright © 2016 KevCol Labs LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol WeatherDataDelegate {
    func setWeather(weather: Weather)
    func weatherErrorWithMessage(message: String)
    
}

class WeatherData {
    
    var delegate: WeatherDataDelegate?
    
    func getWeather(city: String) {
        
        if city.characters.count != 5 {
            // This needs validation -- just ran out of time
            print("TRY A REAL ZIP CODE WISEGUY")
            
        } else {
            
            let appID = "8a20e1b6e0c17bd5673bf5e5dbdf5fb9"
            let path = "http://api.openweathermap.org/data/2.5/weather?zip=\(city),us&appid=\(appID)"
            let url = NSURL(string: path)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!) {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    print("********")
                    print(httpResponse.statusCode)
                    print("********")
                }
                
                let json = JSON(data: data!)
                let lon = json["coord"]["lon"].double
                let lat = json["coord"]["lat"].double
                let temp = json["main"]["temp"].double
                let name = json["name"].string
                let desc = json["weather"][0]["description"].string
                let icon = json["weather"][0]["icon"].string
                
                let weather = Weather(cityName: name!, temp: temp!, description: desc!, icon: icon!, lon: lon!, lat: lat!)
                
                if self.delegate != nil {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.setWeather(weather)
                    })
                    
                }
                
            }
            
            task.resume()
        }
    }
    
}
