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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    func postPins() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
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
    
    func getPins(completion: (dict: [[String:AnyObject]]?) -> Void) {
        /* from udacity api docs */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("-createdAt,-updatedAt", forHTTPHeaderField: "order")
        request.addValue("100", forHTTPHeaderField: "limit")
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
            print(parsedResult)
            let resultsDict = parsedResult["results"]! as? [[String:AnyObject]]!
            if let results = parsedResult!["results"]! {
                print(results)
                let uniqueKey = results["uniqueKey"]
                print("UNIQUE KEY: \(uniqueKey)")
                print("results: \(results)")
            }
            if (resultsDict != nil) {
                completion(dict: resultsDict!)
            } else {
                completion(dict: nil)
            }
        }
        task.resume()
    }
    
}