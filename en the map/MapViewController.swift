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
    var studentInfoStorageModel = StudentInfoStorageModel.sharedInstance
    var locationsDict: [[String:AnyObject]]?
    var hasPin: Bool?
    var userID: String?
    var madePin = false
    let parseNetworking = ParseNetworking()
    //let annotation = StudentInformation.annotationsDict: ([[String: AnyObject]])
    let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
    //let udacityNetworking = UdacityNetworking()
    func alert(title: String, message: String){
        /* http://nshipster.com/uialertcontroller/ */
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
      //  var infoArray = [StudentInformation]()
        for dict in locations! {
           // print("dictionary: \(dictionary)")
           // print("lat: ", dictionary["latitude"])
            if(dict["latitude"] != nil && dict["longitude"] != nil && dict["firstName"] != nil && dict["lastName"] != nil && dict["mediaURL"] != nil) {

                let lat = CLLocationDegrees(dict["latitude"] as! Double)

                let long = CLLocationDegrees(dict["longitude"] as! Double)
            
                let first = dict["firstName"] as! String
            
                let last = dict["lastName"] as! String
            
                let mediaURL = dict["mediaURL"] as! String
            
                let studentInfo = StudentInformation(annotationsDict: ["firstName": first, "lastName": last, "mediaURL": mediaURL, "latitude": lat, "longitude": long])
                var infoArray = [StudentInformation]()
                //infoArray.append(studentInfo)
                
                
                self.studentInfoStorageModel.infoArray.append(studentInfo)
                //infoArray.append(studentInfo)
                print("studentInfoStorageModel.infoArray:", studentInfoStorageModel.infoArray)
                //print("info array:", infoArray)
            }
            
        }
        self.dropPins()
    }
    
    func dropPins() {
        // from Pin Sample App
        print("dropPins")
        print(studentInfoStorageModel.infoArray)
        var annotations = [MKPointAnnotation]()
        for (index, _) in self.studentInfoStorageModel.infoArray.enumerate() {
            let annotation = MKPointAnnotation()
            let lat = studentInfoStorageModel.infoArray[index].latitude
            let long = studentInfoStorageModel.infoArray[index].longitude
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(studentInfoStorageModel.infoArray[index].firstName) \(studentInfoStorageModel.infoArray[index].lastName)"
            annotation.subtitle = studentInfoStorageModel.infoArray[index].mediaURL
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
            let pinColor = UIColor.orangeColor()//(red: 0.45, green: 1.78, blue: 2.25, alpha: 1)
            pinView!.pinTintColor = pinColor
            //pinView!.image = UIImage(named: "PinImage")
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
        parseNetworking.getPins({(dict) -> Void in
            if (dict != nil) {
                self.createPins(dict)
            } else {
                self.alert("Download Failed", message: "Unable to download data from server")
            }
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
        if (appDelegate.madePin == true) {
            self.mapView.removeAnnotations(self.mapView.annotations) //method from: http://stackoverflow.com/questions/32850094/how-do-i-remove-all-map-annotations-in-swift-2
            centerMapOnLocation(CLLocation(latitude: appDelegate.latitue!, longitude: appDelegate.longitude!))
            appDelegate.madePin = false
            parseNetworking.getPins({(dict) -> Void in
                if (dict != nil) {
                    self.createPins(dict)
                } else {
                    self.alert("Download Failed", message: "Unable to download data from server")
                }
            })
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
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PinInfo")
        self.presentViewController(controller, animated: true, completion: nil)
        //}
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        UdacityNetworking().deleteSession()
        appDelegate.madePin = false
        appDelegate.loggedOut = true
        self.dismissViewControllerAnimated(true, completion: nil)
        print("session deleted :)")
    }
}