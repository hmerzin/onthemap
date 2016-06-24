//
//  MapViewController.swift
//  en the map
//
//  Created by Harry Merzin on 5/29/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UITabBarControllerDelegate, UIAlertViewDelegate {
    static let sharedInstance = MapViewController()
    @IBOutlet weak var mapView: MKMapView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var locationsDict: [[String:AnyObject]]?
    var hasPin: Bool?
    var userID: String?
    var madePin = false
    
    func alert(title: String, message: String){
    }
    
    func getPins() {
        /* from udacity api docs */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            //print(parsedResult)
            let resultsDict = parsedResult["results"]! as? [[String:AnyObject]]!
            self.appDelegate.infoDict = resultsDict!
            let results = parsedResult!["results"]!
            print(results!)
            let uniqueKey = results!["uniqueKey"]
            print("UNIQUE KEY: \(uniqueKey)")
            print("results: \(results!)")
            self.locationsDict = resultsDict!
            self.dropPins(resultsDict!)
        }
        task.resume()
    }
    
    func getPin() {
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error
                print(error)
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
//    func checkForPin(dictionary: [[String: AnyObject]]) -> Bool {
//        let locations = dictionary
//        var returnVal: Bool?
//        for dictionary in locations {
//            let uniqueKey = dictionary["uniqueKey"] as! String
//            if(uniqueKey == "8401124478"){
//                self.appDelegate.hasPin = true
//                returnVal = true
//            }else{
//                print("the dictionary does not contain the user id")
//                returnVal =  false
//            }
//        }
//        return returnVal!
//    }
    
    func dropPins(dictionary: [[String: AnyObject]]?) {
        // from Pin Sample App
        print("dropPins")
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        let locations = dictionary
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in locations! {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // MARK: Map stuff (from PinSample App)
        // print("we got to viewForAnnotation")
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            pinView?.rightCalloutAccessoryView?.tintColor = UIColor.orangeColor()
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // MARK: Map stuff (from PinSample App)
        //print("we got to calloutAccessoryControlTapped")
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                if((NSURL(string: toOpen)) != nil) {
                app.openURL(NSURL(string: toOpen)!)
                }
            }
        }
    }
    // from ray wenderlich's mk tutorial 
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getPins()
        // MARK: Not map things
        /* http://stackoverflow.com/questions/26956728/changing-the-status-bar-color-for-specific-viewcontrollers-using-swift-in-ios8 */
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        /* http://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift */
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        /* http://stackoverflow.com/questions/26048765/how-to-set-navigation-bar-font-colour-and-size */
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Made pin: \(self.appDelegate.madePin)")
        if (self.appDelegate.madePin == true) {
            centerMapOnLocation(CLLocation(latitude: self.appDelegate.latitue!, longitude: self.appDelegate.longitude!))
        }
    }
    
    func deleteSession() {
        /* from udacity api docs */
        self.dismissViewControllerAnimated(true, completion: {})
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print(error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    @IBAction func pinInfoButtonPressed(sender: AnyObject) {
        //print("\(self.appDelegate.hasPin!)")
//        if(self.appDelegate.hasPin! == true) {
//            /* http://nshipster.com/uialertcontroller/ */
//            let alertController = UIAlertController(title: "WAIT", message: "You already have a pin... Would you like to override?", preferredStyle: .Alert)
//            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("URLViewController")
//                self.presentViewController(controller, animated: true, completion: nil)
//                print("okee")
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//                print("cancelled")
//                return
//            }
//            alertController.addAction(OKAction)
//            alertController.addAction(cancelAction)
//            self.presentViewController(alertController, animated: true, completion: nil)
        //}else{
            //self.appDelegate.hasPin = false
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("URLViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        //}
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        deleteSession()
        self.appDelegate.madePin = false
        print("session deleted :)")
    }
}