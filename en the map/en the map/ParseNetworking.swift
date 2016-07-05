//
//  ParseNetworking.swift
//  en the map
//
//  Created by Harry Merzin on 6/24/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit
class ParseNetworking {
    let mapViewController = MapViewController()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
}