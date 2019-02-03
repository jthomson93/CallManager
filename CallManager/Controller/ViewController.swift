//
//  ViewController.swift
//  CallManager
//
//  Created by James Thomson on 15/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        print("EMAIL SIGN IN BUTTON PRESSED")
        Auth.auth().signIn(withEmail: userNameField.text!, password: passwordTxtFld.text!) { (user, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                self.performSegue(withIdentifier: "goToEventWindowFromLogin", sender: self)
            }
        }
    }
  
    @objc func didSignIn()  {
        
        // Add your code here to push the new view controller
        performSegue(withIdentifier: "goToEventWindowFromLogin", sender: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func goodLoginPressed(_ sender: Any) {
        print("Google Sign IN Actioned")
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func registerAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "goRegisterAccount", sender: self)
    }
    
    
}

