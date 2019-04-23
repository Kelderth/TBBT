//
//  LoginViewModel.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/14/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

struct KeychainConfiguration {
    static let serviceName: String = "TheBigBangTheory"
    static let accessGroup: String? = nil
}

class LoginViewModel {
    let bsLogin = BiometricRecognition()
    
    private let username: String = "admin"
    private let password: String = "admin"
    
    private enum LoginWarnings: String {
        case missedValue = "Username or Password not found."
        case mismatchValues = "Invalid Credentials."
    }
    
    // MARK: - Singleton
    static let shared = LoginViewModel()
    private init() {}
    
    func checkLogin(user: String?, password: String?, completion: @escaping (String?) -> Void) {
        guard let user = user else { return }
        guard let password = password else { return }
        
        if user == "" || password == "" {
            completion(LoginWarnings.missedValue.rawValue)
            return
        } else if user != self.username || password != self.password {
            completion(LoginWarnings.mismatchValues.rawValue)
            return
        } else {
            completion(nil)
        }
    }
    
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
