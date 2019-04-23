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
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        biometricTypeAvailable()
        loginButtonStatus()
        
        if LoginViewModel.shared.getUseBiometricDefaults() {
            enableBiometrics()
        }
        
        passwordLabel.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButtonStatus()
    }
    
    func loginButtonStatus() {
        if LoginViewModel.shared.checkUserExist() {
            loginButton.setTitle("Login", for: .normal)
            loginButton.tag = LoginViewModel.shared.loginButtonTagValue()
            usernameLabel.text = LoginViewModel.shared.getUsernameDefaults()
            passwordLabel.becomeFirstResponder()
        } else {
            usernameLabel.becomeFirstResponder()
            loginButton.setTitle("Create User", for: .normal)
            loginButton.tag = LoginViewModel.shared.loginButtonTagValue()
        }
    }
    
    @IBAction func userAuthenticity(_ sender: UIButton) {
        guard let newAccountName = usernameLabel.text, let newAccountPassword = passwordLabel.text, !newAccountName.isEmpty, !newAccountPassword.isEmpty else {
            warningMessage(title: "Login Message", message: "Username or Password not found, Please try again.")
            return
        }
        
        if LoginViewModel.shared.checkUserExist() {
            LoginViewModel.shared.checkLogin(user: usernameLabel.text, password: passwordLabel.text) { (success, response) in
                if let response = response {
                    self.warningMessage(title: "Login Message", message: response)
                    return
                }
                self.appAccess()
            }
        } else {
            if !LoginViewModel.shared.checkUserExist() && usernameLabel.hasText {
                LoginViewModel.shared.setUsernameDefaults(username: newAccountName)
                
                do {
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: newAccountName, accessGroup: KeychainConfiguration.accessGroup)
                    try passwordItem.savePassword(password: newAccountPassword)
                } catch {
                    print(error.localizedDescription)
                }
                
                LoginViewModel.shared.loginKeyEnabled()
                loginButton.tag = LoginViewModel.shared.loginButtonTagValue()
                appAccess()
            }
        }
        
        passwordLabel.text = ""
        passwordLabel.becomeFirstResponder()
    }
    
    @IBAction func activateTouchID(_ sender: UIButton) {
        if !LoginViewModel.shared.getUseBiometricDefaults() {
            enableBiometrics()
        } else {
            disableBiometrics()
        }
    }
    
    func enableBiometrics() {
        touchIDButton.setImage(UIImage(named: LoginViewModel.shared.biometricImageName()+"_on"), for: .normal)
        LoginViewModel.shared.setUseBiometricDefaults()
        
        touchIDStatus()
    }
    
    func disableBiometrics() {
        touchIDButton.setImage(UIImage(named: LoginViewModel.shared.biometricImageName()+"_off"), for: .normal)
        LoginViewModel.shared.unsetUseBiometricDefaults()
    }
    
    func biometricTypeAvailable() {
        switch LoginViewModel.shared.biometricTypeAvailable() {
        case .faceID:
            touchIDButton.setImage(UIImage(named: "faceid_off"), for: .normal)
        case .touchID:
            touchIDButton.setImage(UIImage(named: "touchid_off"), for: .normal)
        default:
            touchIDButton.isHidden = true
        }
    }
    
    func touchIDStatus() {
        if LoginViewModel.shared.getUseBiometricDefaults() {
            LoginViewModel.shared.biometricLoginVerification { (loginResponse, warningMessage) in
                if loginResponse {
                    self.appAccess()
                } else {
                    guard let warningMessage = warningMessage else { return }
                    self.warningMessage(title: "Login Message", message: warningMessage)
                }
            }
        }
    }
    
    func warningMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Try Again", style: .cancel, handler: { (UIAlertAction) in
            if LoginViewModel.shared.checkUserExist() {
                self.passwordLabel.becomeFirstResponder()
            } else {
                self.usernameLabel.becomeFirstResponder()
            }
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
