//
//  UdacityNetworking.swift
//  en the map
//
//  Created by Harry Merzin on 6/23/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit
class UdacityNetworking: NSObject{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    func login(completionHandler: (connection: Bool?, statusCode: Int?, error: NSError?) -> Void, username: String?, password: String?) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("\(error)")
                if(error!.code == -1009){
                    print("no connection")
                    performUIUpdatesOnMain(){
                        completionHandler(connection: false, statusCode: nil, error: error)
                        return
                    }
                }else{
                    completionHandler(connection: nil, statusCode: nil, error: error)
                    print(error!.code)
                    return
                }
            }
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            // print(parsedResult!)                                //prints json
            let userDict = parsedResult["account"]                //account dictionary
            let idKey = userDict!!["key"] as? String              //sets userID from account dictionary
            print("this is the account dictionary: \(parsedResult["account"])") //prints info about account dict
            print("this is the actual key: \(idKey!)")          //prints actual userid key
            self.getUserData(idKey!)
            // if let parsedResult{} variable binding in a condition requires an initializer
            completionHandler(connection: true, statusCode: statusCode, error: nil)
        }
        task.resume()
    }
    
    func getUserData(key: String) {
        print("the key from getUserData is: \(key)")
        //from udacity API docs
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(key)")!)   //\(AppDelegate().UserID)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            let parsedResult: AnyObject
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            print(parsedResult)
            let userDict = parsedResult["user"]
            let firstName = userDict!!["first_name"] as? String
            let lastName = userDict!!["last_name"] as? String
            self.appDelegate.lastName = lastName!
            self.appDelegate.firstName = firstName!
            print("first name is: \(self.appDelegate.firstName!)")
            print("last name is: \(self.appDelegate.lastName!)")
            print("your full name is: \(firstName!) \(lastName!)-- magic")
            print("It works... *jazz hands*")
        }
        task.resume()
    }
}
