//
//  LoginViewController.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/14/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var touchIDButton: UIButton!

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.becomeFirstResponder()
        
        biometricAuthenticationON()
    }
    
    @IBAction func userAuthenticity(_ sender: UIButton) {
        LoginViewModel.shared.checkLoginKeys(for: usernameLabel.text, password: passwordLabel.text) { (response) in
            if let response = response {
                self.warningMessage(message: response)
                return
            }
            self.appAccess()
        }
        usernameLabel.text = ""
        passwordLabel.text = ""
        usernameLabel.becomeFirstResponder()
    }
    
    @IBAction func activateTouchID(_ sender: UIButton) {
        print("Activating Touch ID...")
        guard let buttonLabel = touchIDButton.currentTitle else { return }

        if buttonLabel == "Sign in with TouchID" {
            defaults.set(true, forKey: "UseTouchID")
//            defaults.set(passwordLabel.text, forKey: "userPassword")
            touchIDButton.setTitle("Disable TouchID", for: .normal)
        } else {
            defaults.set(false, forKey: "UseTouchID")
            touchIDButton.setTitle("Sign in with TouchID", for: .normal)

        }
    }
    
    func biometricAuthenticationON() {
        touchIDStatus()
    }
    
    func touchIDStatus() {
        let temporal = defaults.bool(forKey: "UseTouchID")
        if temporal {
            touchIDButton.setTitle("Disable TouchID", for: .normal)
//            warningMessage(message: "TouchID ON!")
            LoginViewModel.shared.biometricLoginVerification { (loginResponse, warningTitle, warningMessage) in
                print("just messing arround with Biometrics")
                if loginResponse {
                    self.appAccess()
                }
            }
        } else {
            touchIDButton.setTitle("Sign in with TouchID", for: .normal)
        }
    }
    
    func warningMessage(message: String) {
        let alert = UIAlertController(title: "Login Message", message: message, preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Try Again", style: .cancel, handler: { (UIAlertAction) in
            self.usernameLabel.becomeFirstResponder()
        })
        alert.addAction(actionOne)
        self.present(alert, animated: true)
    }
    
    func appAccess() {
        performSegue(withIdentifier: "userVerified", sender: self)
    }

}
