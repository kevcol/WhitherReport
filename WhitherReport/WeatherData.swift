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


// http://api.openweathermap.org/data/2.5/weather?zip=91301,us&APPID=8a20e1b6e0c17bd5673bf5e5dbdf5fb9

class WeatherData {
    
    var delegate: WeatherDataDelegate?
    
    func getWeather(city: String) {
        
        if city.characters.count != 5 {
            print("FUCK YOU -- TRY A REAL ZIP CODE WISEGUY")
        } else {
            
            let appID = "8a20e1b6e0c17bd5673bf5e5dbdf5fb9"
            
            //let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=\(appID)"
            
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
                
                let weather = Weather(cityName: name!, temp: temp!, description: desc!, icon: icon!)
                
                if self.delegate != nil {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.setWeather(weather)
                    })
                    
                }
                
                print("City: \(name) Lat: \(lat!), Lon: \(lon!), temp: \(temp!), desc: \(desc)")
                
            }
            
            task.resume()
            
        }
        
        
        
    }
    
    
}
