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

    @IBOutlet weak var mapView: MKMapView!
    var locationsDict: [[String:AnyObject]]?
    var hasPin: Bool?
    var userID: String?
    var madePin = false
    //let annotation = StudentInformation.annotationsDict: ([[String: AnyObject]])
    let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
    //let parseNetworking = ParseNetworking()
    //let udacityNetworking = UdacityNetworking()
    
    func alert(title: String, message: String){
    }
    
    //    func getPin() {
    //        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D"
    //        let url = NSURL(string: urlString)
    //        let request = NSMutableURLRequest(URL: url!)
    //        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    //        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    //        let session = NSURLSession.sharedSession()
    //        let task = session.dataTaskWithRequest(request) { data, response, error in
    //            if error != nil { // Handle error
    //                print(error)
    //                return
    //            }
    //            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
    //        }
    //        task.resume()
    //    }
    //
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
        if let controller = appDelegate.window?.rootViewController?.presentedViewController as? MapViewController {
            controller.dropPins(infoArray)
        }
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
        } else {
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
        self.mapView.delegate = self
        StudentLocationViewModel().getPins({(dict) -> Void in
            self.createPins(dict)
        })
        // MARK: Not map things
        /* http://stackoverflow.com/questions/26956728/changing-the-status-bar-color-for-specific-viewcontrollers-using-swift-in-ios8 */
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        /* http://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift */
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        /* http://stackoverflow.com/questions/26048765/how-to-set-navigation-bar-font-colour-and-size */
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    override func viewDidAppear(animated: Bool) {
        print("Made pin: \(AppDelegate().madePin)")
        if (AppDelegate().madePin == true) {
            centerMapOnLocation(CLLocation(latitude: AppDelegate().latitue!, longitude: AppDelegate().longitude!))
        }
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
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LocationViewController")
        self.presentViewController(controller, animated: true, completion: nil)
        //}
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        UdacityNetworking().deleteSession()
        AppDelegate().madePin = false
        self.dismissViewControllerAnimated(true, completion: nil)
        print("session deleted :)")
    }
}