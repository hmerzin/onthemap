//
//  TableViewController.swift
//  en the map
//
//  Created by Harry Merzin on 6/8/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        /* http://stackoverflow.com/questions/26956728/changing-the-status-bar-color-for-specific-viewcontrollers-using-swift-in- ios8 */
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        /* http://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift */
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        /* http://stackoverflow.com/questions/26048765/how-to-set-navigation-bar-font-colour-and-size */
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        print(self.appDelegate.infoDict)
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(controller, animated: true, completion: nil)
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
        self.appDelegate.madePin = false
        print("session deleted :)")
    }
    
    
    @IBAction func pinInfoButtonPressed(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("URLViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.appDelegate.infoDict?.count)!
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dictionary = self.appDelegate.infoDict
        let CellID = "Pin Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID, forIndexPath: indexPath) as! PinCell
        let person = dictionary![indexPath.row]
        let first = person["firstName"]!
        let last = person["lastName"]!
        let url = person["mediaURL"]!
        cell.nameLabel.text = "\(first) \(last)"
        cell.urlLabel.text = "\(url)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dictionary = appDelegate.infoDict![indexPath.row]
        let app = UIApplication.sharedApplication()
        let toOpen = dictionary["mediaURL"]
        print(toOpen)
        app.openURL(NSURL(string: "\(toOpen!)")!)
    }
}
