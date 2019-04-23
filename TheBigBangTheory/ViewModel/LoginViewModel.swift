//
//  LoginViewModel.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/14/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import LocalAuthentication

struct KeychainConfiguration {
    static let serviceName: String = "TheBigBangTheory"
    static let accessGroup: String? = nil
}

class LoginViewModel {
    let bsLogin = BiometricRecognition()
    let defaults = UserDefaults.standard
    private let createLoginButtonTag = 0
    private let loginButtonTag = 1
    
    private enum LoginWarnings: String {
        case valueNotFound = "Username or Password not found."
        case invalidCredential = "Invalid Credentials."
    }
    
    // MARK: - Singleton
    static let shared = LoginViewModel()
    private init() {}
    
    func checkUserExist() -> Bool {
        return defaults.bool(forKey: "hasLoginKey")
    }
    
    func loginButtonTagValue() -> Int {
        if checkUserExist() {
            return loginButtonTag
        }
        return createLoginButtonTag
    }
    
    func loginKeyEnabled() {
        defaults.set(true, forKey: "hasLoginKey")
    }
    
    func loginKeyDisabled() {
        defaults.set(false, forKey: "hasLoginKey")
    }
    
    func setUsernameDefaults(username: String) {
        defaults.set(username, forKey: "username")
    }
    
    func getUsernameDefaults() -> String {
        return defaults.value(forKey: "username") as! String
    }
    
    func setUseBiometricDefaults() {
        defaults.set(true, forKey: "UseTouchID")
    }
    
    func unsetUseBiometricDefaults() {
        defaults.set(false, forKey: "UseTouchID")
    }
    
    func getUseBiometricDefaults() -> Bool {
        return defaults.bool(forKey: "UseTouchID")
    }
    
    func checkLogin(user: String?, password: String?, completion: @escaping (Bool, String?) -> Void) {
        guard let username = defaults.value(forKey: "username") as? String else { return }
        
        guard let user = user else { completion(false, LoginWarnings.valueNotFound.rawValue); return }
        guard let password = password else { completion(false, LoginWarnings.valueNotFound.rawValue); return }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            
            if user.isEmpty || password.isEmpty {
                completion(false, LoginWarnings.valueNotFound.rawValue)
                return
            } else if user != username || password != keychainPassword {
                completion(false, LoginWarnings.invalidCredential.rawValue)
                return
            }
            completion(password == keychainPassword, nil)
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
}

// MARK: - Biometrics
extension LoginViewModel {
    func biometricAvailable() -> Bool {
        return bsLogin.canEvaluatePolicy()
    }
    
    func biometricTypeAvailable() -> BiometricType {
        return bsLogin.biometricType()
    }
    
    func biometricImageName() -> String {
        let option = biometricTypeAvailable()
        let imageAssetName: String
        switch option {
        case .faceID:
            imageAssetName = "faceid"
        default:
            imageAssetName = "touchid"
        }
        
        return imageAssetName
    }
    
    func biometricLoginVerification(completion: @escaping (Bool, String?) -> Void) {
        DispatchQueue.global().async {
            self.bsLogin.authenticationProcess { (response, warningMessage) in
                if response {
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } else {
                    guard let warningMessage = warningMessage else { return }
                    DispatchQueue.main.async {
                        completion(response, warningMessage)
                    }
                }
            }
        }
    }
}
