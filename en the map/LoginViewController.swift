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

    @IBAction func loginButtonPressed(sender: AnyObject) {
        if(usernameTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true) {
            self.alert("Empty Field", message: "Please fill in both fields to proceed")
            return
        }
        activityIndicator.startAnimating()
        self.loginButton.hidden = true
        UdacityNetworking().login( { (connection,statusCode,error) -> Void in
            performUIUpdatesOnMain{
                self.activityIndicator.stopAnimating() // stops activityIndicator so it hides
                self.loginButton.hidden = false
            }
            if (connection == true && (statusCode >= 200 && statusCode <= 299) && error == nil) {
                performUIUpdatesOnMain{
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")
                    self.presentViewController(controller, animated: true, completion: nil)
                
                }
            }
                // MARK: If it doesn't work check to see why
            else if(connection! == false) {
                performUIUpdatesOnMain{
                    self.alert("No Connection", message: "You don't have a working network connection, please try again when you connect to a network")
                }
            }
            else if(statusCode! == 403) {
                performUIUpdatesOnMain{
                  self.alert("Invalid Credentials", message: "You did not enter valid credentials")
                }
            }
            }, username: self.usernameTextField.text, password: self.passwordTextField.text) //finish all the params
        
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