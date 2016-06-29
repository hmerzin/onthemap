//
//  pin view controller.swift
//  en the map
//
//  Created by Harry Merzin on 6/4/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class EnterLocationViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationField: UITextField!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    @IBOutlet weak var checkButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        /* http://stackoverflow.com/questions/25679075/set-uitextfield-placeholder-color-programmatically */
        locationField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func alert(title: String, message: String){
        /* http://nshipster.com/uialertcontroller/ */
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismiss()
    }
    
    @IBAction func locationEntered(sender: AnyObject) {
        activityIndicator.startAnimating()
        print("pressed")
        appDelegate.locationString = locationField.text!
        if((locationField.text?.isEmpty) == true){
            alert("Field Empty", message: "Please fill in the location field")
            return
        }
        /* http://studyswift.blogspot.com/2014/10/geocodergeocodeaddressstring-show-input.html */
        var placemark: CLPlacemark!
        CLGeocoder().geocodeAddressString(locationField.text!, completionHandler: {(placemarks, error)->Void in
            if error != nil {
                if(error!.code == 8){
                    print(error)
                    self.activityIndicator.stopAnimating()
                    self.alert("Invalid Location", message: "Your location could not be found, please enter an alternate one.")
                    return
                }
            }
            if error == nil {
                placemark = placemarks![0] as CLPlacemark
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude
                self.appDelegate.latitue = self.latitude     //"\(placemark.location?.coordinate.latitude)"
                self.appDelegate.longitude = self.longitude  //"\(placemark.location?.coordinate.longitude)"
                print("latlong \(self.appDelegate.latitue!), \(self.appDelegate.longitude!)")
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("URLVC")
                self.showViewController((controller), sender: self.checkButton)
                self.activityIndicator.stopAnimating()
            }
        })
    }
}

class EnterURLViewController: UIViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var url: String? = nil
    var objectID: String?
    @IBOutlet weak var urlField: UITextField!
    
    func alert(title: String, message: String){
        /* http://nshipster.com/uialertcontroller/ */
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PLEASE DONT BE NIL \(appDelegate.latitue!), \(appDelegate.longitude!)")
        urlField.attributedPlaceholder = NSAttributedString(string: "URL", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.navigationController?.navigationBarHidden = true
    }
    // parse api malfunctioning so I am not able to recieve json to use for the object id
//    func putPins() {
//        let urlString = "https://api.parse.com/1/classes/StudentLocation/8ZExGR5uX8"
//        let url = NSURL(string: urlString)
//        let request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "PUT"
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".dataUsingEncoding(NSUTF8StringEncoding)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { // Handle error…
//                return
//            }
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
//    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismiss()
    }
    
    func postPins() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        // from udacity api docs
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(appDelegate.UserID!)
        print(appDelegate.firstName!)
        print(appDelegate.lastName!)
        print(appDelegate.URL!)
        print(appDelegate.locationString!)
        print(appDelegate.latitue!)
        print(appDelegate.longitude!)
        request.HTTPBody = "{\"uniqueKey\": \"\(appDelegate.UserID!)\", \"firstName\": \"\(appDelegate.firstName!)\", \"lastName\": \"\(appDelegate.lastName!)\",\"mapString\": \"\(appDelegate.locationString!)\", \"mediaURL\": \"\(appDelegate.URL!)\",\"latitude\": \(appDelegate.latitue!), \"longitude\": \(appDelegate.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {// Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
        task.resume()
    }
    
    @IBAction func urlEntered(sender: AnyObject) {
        self.appDelegate.madePin = true
        if((urlField.text?.isEmpty)  == true) {
            alert("Empty URL", message: "Please enter a value in the URL box.")
            return
        }
        url = urlField.text?.lowercaseString
        appDelegate.URL = url
        postPins()
//        if(appDelegate.hasPin == true) {
//            putPins()
//        } else {
//            postPins()
//        }
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PinInfo")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
