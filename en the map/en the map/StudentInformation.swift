//
//  Annotation.swift
//  en the map
//
//  Created by Harry Merzin on 6/25/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import CoreLocation
struct StudentInformation {
    var firstName: String
    var lastName: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    init(annotationsDict: [String: AnyObject]) {
        self.firstName = (annotationsDict["firstName"] as? String)!
        self.lastName = (annotationsDict["lastName"] as? String)!
        self.mediaURL = (annotationsDict["mediaURL"] as? String)!
        self.latitude = (annotationsDict["latitude"] as? Double)!
        self.longitude = (annotationsDict["longitude"] as? Double)!
    }
}