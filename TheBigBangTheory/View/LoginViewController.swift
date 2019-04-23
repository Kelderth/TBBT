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
        biometricTypeAvailable()
        
        passwordLabel.resignFirstResponder()
        
        if LoginViewModel.shared.biometricAvailable() {
            enableBiometrics()
        } else {
            disableBiometrics()
        }
    }
    
    @IBAction func userAuthenticity(_ sender: UIButton) {
        LoginViewModel.shared.checkLogin(user: usernameLabel.text, password: passwordLabel.text) { (response) in
            if let response = response {
                self.warningMessage(title: "Login Message", message: response)
                return
            }
            self.appAccess()
        }
        usernameLabel.text = ""
        passwordLabel.text = ""
        usernameLabel.becomeFirstResponder()
    }
    
    @IBAction func activateTouchID(_ sender: UIButton) {
        guard let buttonLabel = touchIDButton.currentTitle else { return }

        if buttonLabel == "Sign in with TouchID / FaceID" {
            enableBiometrics()
            biometricAuthenticationON()
        } else {
            disableBiometrics()
        }
    }
    
    func enableBiometrics() {
        defaults.set(true, forKey: "UseTouchID")
        touchIDButton.setImage(UIImage(named: LoginViewModel.shared.biometricImageName()+"_on"), for: .normal)
        touchIDButton.setTitle("Disable TouchID / FaceID", for: .normal)
    }
    
    func disableBiometrics() {
        defaults.set(false, forKey: "UseTouchID")
        touchIDButton.setImage(UIImage(named: LoginViewModel.shared.biometricImageName()+"_off"), for: .normal)
        touchIDButton.setTitle("Sign in with TouchID / FaceID", for: .normal)
    }
    
    func biometricTypeAvailable() {
        switch LoginViewModel.shared.biometricTypeAvailable() {
        case .faceID:
            touchIDButton.setImage(UIImage(named: "faceid_off"), for: .normal)
        default:
            touchIDButton.setImage(UIImage(named: "touchid_off"), for: .normal)
        }
        
    }
    
    func biometricAuthenticationON() {
        touchIDStatus()
    }
    
    func touchIDStatus() {
        let temporal = defaults.bool(forKey: "UseTouchID")
        if temporal {
            touchIDButton.setTitle("Disable TouchID / FaceID", for: .normal)
            LoginViewModel.shared.biometricLoginVerification { (loginResponse, warningMessage) in
                if loginResponse {
                    self.appAccess()
                } else {
                    guard let warningMessage = warningMessage else { return }
                    self.warningMessage(title: "Touch ID - Message", message: warningMessage)
                    if warningMessage == "Touch ID / Face ID not available." {
                        self.disableBiometrics()
                        self.touchIDButton.isHidden = true
                    }
                }
            }
        } else {
            touchIDButton.setTitle("Sign in with TouchID / FaceID", for: .normal)
        }
    }
    
    func warningMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Try Again", style: .cancel, handler: { (UIAlertAction) in
            self.usernameLabel.becomeFirstResponder()
        })
        alert.addAction(actionOne)
        self.present(alert, animated: true)
    }
    
    func appAccess() {
        performSegue(withIdentifier: "userVerified", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
