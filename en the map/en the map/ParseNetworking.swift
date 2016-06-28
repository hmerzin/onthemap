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
            Model().createPins(resultsDict)
        }
        task.resume()
    }
}