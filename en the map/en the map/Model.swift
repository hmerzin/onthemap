//
//  Model.swift
//  en the map
//
//  Created by Harry Merzin on 6/26/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

class Model {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func createPins(dictionary: [[String: AnyObject]]?) {
        let locations = dictionary
        var infoArray = [StudentInformation]()
        for dictionary in locations! {
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            let studentInfo = StudentInformation(annotationsDict: ["first": first, "last": last, "mediaURL": mediaURL, "latitude": lat, "longitude": long])
            appDelegate.studentInfoArray?.append(studentInfo)
            infoArray.append(studentInfo)
        }
        self.dropPins(infoArray)
        
    }
    
    func dropPins(studentInfo: [StudentInformation]) {
        // from Pin Sample App
        print("dropPins")
        var annotations = [MKPointAnnotation]()
        for (index, _) in studentInfo.enumerate() {
            let annotation = MKPointAnnotation()
            let infoArray = studentInfo[index]
            let dict = infoArray.annotationDict
            let lat = dict["latitude"] as? Double
            let long = dict["longitude"] as? Double
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            annotation.title = "\(dict["first"]) \(dict["last"])"
            annotation.subtitle = dict["mediaURL"] as? String
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        //self.mapView.addAnnotations(annotations)
        print("annotations: ",annotations)
        MapViewController().addAnnotations(annotations)
    }
    
}