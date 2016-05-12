//
//  LocationViewController.swift
//  WhitherReport
//
//  Created by Kevin Colligan on 5/11/16.
//  Copyright © 2016 KevCol Labs LLC. All rights reserved.
//

import UIKit
import MapKit

struct GlobalData
{
    static var celsius: Bool = false
}

class LocationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WeatherDataDelegate {
    
    // MARK: Properties
    let weatherData = WeatherData()
    
    //var celsius: Bool!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zipTextField.delegate = self
        weatherData.delegate = self
        
        GlobalData.celsius = false
        
        // Set up views if editing existing location
        if let location = location {
            navigationItem.title = location.zip
            zipTextField.text   = location.zip
            photoImageView.image = location.photo
            
            let cityName = location.zip
            weatherData.getWeather(cityName)
            
        } else {
            
            // hide some junk
            tempLabel.hidden = true
            iconImage.hidden = true
            descriptionLabel.hidden = true
            cityLabel.hidden = true
            mapView.hidden = true
        }
        
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable save while editing
        //saveButton.enabled = false
    }
    
    func checkValidZip() {
        // Disable save if text field is empty
        let text = zipTextField.text ?? ""
        
        if text.characters.count == 5 {
        saveButton.enabled = true
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss picker if canceled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Use original photo
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display selected image
        photoImageView.image = selectedImage
        // Dismiss picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Dismiss VC differently depending on presentation (modal or push)
    
        let isPresentingInAddLocationMode = presentingViewController is UINavigationController
        
        if isPresentingInAddLocationMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let zip = zipTextField.text ?? ""
            let photo = photoImageView.image
            // Set the location to be passed to LocationTableViewController after the unwind segue.
            location = Location(zip: zip, photo: photo)
        }
    }
    
    // MARK: Weather
    func setWeather(weather: Weather) {
        
        let formatter = NSNumberFormatter()
        let f = formatter.stringFromNumber(weather.tempF)!
        let c = formatter.stringFromNumber(weather.tempC)!
        
        cityLabel.text = weather.cityName
        
        // center the map
        let initialLocation = CLLocation(latitude: weather.lat, longitude: weather.lon)
        centerMapOnLocation(initialLocation)
        print("\(weather.lat) and \(weather.lon)")
        
        if GlobalData.celsius == false {
            tempLabel.text = "\(f)"+"˚"
        } else if GlobalData.celsius == true {
            tempLabel.text = "\(c)"+"˚"
        }
        
        descriptionLabel.text = weather.description
        iconImage.image = UIImage(named: weather.icon)
    }
    
    func weatherErrorWithMessage(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
//    Didn't have time to toggle F/C.  Dang
    
//    @IBAction func tempToggle(sender: UIButton) {
//        
//        
//        if GlobalData.celsius == false {
//            farOrCel.setImage(UIImage(named: "celsius.png"), forState: .Normal)
//            GlobalData.celsius = true
//            // change temp
//            let tempDigits = Double(tempLabel.text!)
//            let celsiusFromFahrenheit = (tempDigits! - 32) / 1.8
//            // trim number
//            tempLabel.text = "\(celsiusFromFahrenheit)"
//
//            
//        } else if GlobalData.celsius == true {
//            farOrCel.setImage(UIImage(named: "fahrenheit.png"), forState: .Normal)
//            GlobalData.celsius = false
//            // change temp
//            let tempDigits = Double(tempLabel.text!)
//            let fahrenheitFromCelsius = (tempDigits! * 1.8) + 32
//            // trim number
//            tempLabel.text = "\(fahrenheitFromCelsius)"
//            
//        }
//
//    }
    

    // MARK: Actions
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        // Hide keyboard ... just in case
        zipTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        // Pix from the photo library only
        imagePickerController.sourceType = .PhotoLibrary
        
        // Notify ViewController when user picks pic
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

}

