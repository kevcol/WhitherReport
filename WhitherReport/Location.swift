//
//  Location.swift
//  WhitherReport
//
//  Created by Kevin Colligan on 5/11/16.
//  Copyright © 2016 KevCol Labs LLC. All rights reserved.
//

import UIKit

class Location: NSObject, NSCoding {
    
    // MARK: Properties
    var zip: String
    var photo: UIImage?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("locations")
    
    // MARK: Types
    struct PropertyKey {
        static let zipKey = "zip"
        static let photoKey = "photo"
    }
    
    // MARK: Initialization
    init?(zip: String, photo: UIImage?) {
        
        // Initialize stored properties
        self.zip = zip
        self.photo = photo
        
        super.init()
        
        // Initialization should fail if there is no zip
        if zip.isEmpty  {
            return nil
        }
        
        }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(zip, forKey: PropertyKey.zipKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let zip = aDecoder.decodeObjectForKey(PropertyKey.zipKey) as! String
        // Because photo is an optional property, use conditional cast
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        // Must call designated initializer.
        self.init(zip: zip, photo: photo)
    
    }
}

