//
//  LocationTableViewController.swift
//  WhitherReport
//
//  Created by Kevin Colligan on 5/11/16.
//  Copyright © 2016 KevCol Labs LLC. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    // MARK: Properties
    let weatherData = WeatherData()
    var locations = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved meals, otherwise load sample data.
        if let savedLocations = loadLocations() {
            locations += savedLocations
        } else {
            // Load the sample data
            loadSampleMeals()
        }

       
    }
    
    func loadSampleMeals() {
        
        let photo1 = UIImage(named: "calabasas")!
        let location1 = Location(zip: "91301", photo: photo1)!
        
        let photo2 = UIImage(named: "bridgeport")!
        let location2 = Location(zip: "06610", photo: photo2)!
        
        let photo3 = UIImage(named: "beverlyHills")!
        let location3 = Location(zip: "91210", photo: photo3)!
        
        locations += [location1, location2, location3]
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LocationTableViewCell"

        let cell = tableView.dequeueReusableCellWithIdentifier("LocationTableViewCell", forIndexPath: indexPath) as! LocationTableViewCell
        
        // Fetches the appropriate location for the data source layout.
        let location = locations[indexPath.row]
        
        cell.zipLabel.text = location.zip
        cell.photoImageView.image = location.photo
        
        return cell
    }
    
    
    @IBAction func unwindToLocationList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? LocationViewController, location = sourceViewController.location {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update existing location
                locations[selectedIndexPath.row] = location
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new location
                let newIndexPath = NSIndexPath(forRow: locations.count, inSection: 0)
                locations.append(location)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
        // Save the locations
        saveLocations()
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            locations.removeAtIndex(indexPath.row)
            saveLocations()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            
            let locationDetailViewController = segue.destinationViewController as! LocationViewController
            
            // Get the cell that generated this segue.
            if let selectedLocationCell = sender as? LocationTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedLocationCell)!
                let selectedLocation = locations[indexPath.row]
                locationDetailViewController.location = selectedLocation
                
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding location")
        }
    }
    

    // MARK: NSCoding
    
    func saveLocations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locations, toFile: Location.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save locations...")
        }
    }
    
    func loadLocations() -> [Location]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Location.ArchiveURL.path!) as? [Location]
    }
}



