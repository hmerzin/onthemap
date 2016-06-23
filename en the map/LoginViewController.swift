//
//  Login.swift
//  on the map
//
//  Created by Harry Merzin on 5/29/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate  {
    // MARK: Interface Interactions
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameIcon: UILabel!
    @IBOutlet weak var passwordIcon: UILabel!
    let session: String? = nil
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func alert(title: String, message: String){
        /* http://nshipster.com/uialertcontroller/ */
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getUserData(key: String) {
        print("the key from getUserData is: \(key)")
        print("the key from appdelegate is: \(appDelegate.UserID!)")
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
            print("user id is: \(self.appDelegate.UserID!)")
            print("first name is: \(self.appDelegate.firstName!)")
            print("last name is: \(self.appDelegate.lastName!)")
            print("your full name is: \(firstName!) \(lastName!)-- magic")
            print("It works... *jazz hands*")
        }
        task.resume()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if(usernameTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true) {
            self.alert("Empty Field", message: "Please fill in both fields to proceed")
            return
        }
        activityIndicator.startAnimating()
        /* from udacity api documentation */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(usernameTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.activityIndicator.stopAnimating()
                print("\(error)")
                if(error!.code == -1009){
                    print("no connection")
                    performUIUpdatesOnMain(){
                        self.alert("No Connection", message: "There appears to be an issue connecting to the network, please try again when you have better connection")
                    }
                }else{
                    print(error!.code)
                    print("that didn't work")
                }
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                performUIUpdatesOnMain {
                    self.alert("Invalid Credentials", message: "Please enter valid credentials to continue")
                    self.activityIndicator.stopAnimating()
                    return
                }
                return
            }
            if error == nil {
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
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
            self.appDelegate.UserID = idKey!                    //assigns the the key to UserID variable in the AppDelegate
            print(self.appDelegate.UserID)
            self.getUserData(self.appDelegate.UserID!)
            // if let parsedResult{} variable binding in a condition requires an initializer
            self.activityIndicator.stopAnimating()
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        /* http://stackoverflow.com/questions/26956728/changing-the-status-bar-color-for-specific-viewcontrollers-using-swift-in-ios8 */
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        /* http://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift */
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        /* http://stackoverflow.com/questions/26048765/how-to-set-navigation-bar-font-colour-and-size */
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        print("ViewDidLoad")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}