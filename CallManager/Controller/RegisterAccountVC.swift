//
//  RegisterAccountVC.swift
//  CallManager
//
//  Created by James Thomson on 29/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class RegisterAccountVC: UIViewController {
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func errorCheckLoginValues(user: String, pass: String) -> Bool {
        if user.isEmpty == true || pass.isEmpty == true {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func completeRegistrationPressed(_ sender: Any) {
        if errorCheckLoginValues(user: emailTxtFld.text!, pass: passwordTxtFld.text!) {
            Auth.auth().createUser(withEmail: emailTxtFld.text!, password: passwordTxtFld.text!) { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    self.performSegue(withIdentifier: "goToEventWindow", sender: self)
                    
                }
            }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    
}
