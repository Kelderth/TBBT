//
//  LoginViewModel.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/14/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class LoginViewModel {
    let bsLogin = BiometricRecognition()
    
    private let username: String = "admin"
    private let password: String = "admin"
    
    private enum LoginWarnings: String {
        case missedValue = "Username or Password not found."
        case mismatchValues = "Invalid Credentials."
    }
    
    static let shared = LoginViewModel()
    
    private init() {}
    
    func checkLoginKeys(for user: String?, password: String?, completion: @escaping (String?) -> Void) {
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
    
    func biometricLoginVerification(completion: @escaping (Bool, String?, String?) -> Void) {
        DispatchQueue.global().async {
            self.bsLogin.authenticationProcess { (response, warningReason, warningMessage) in
                if response {
                    DispatchQueue.main.async {
                        completion(response, nil, nil)
                    }
                } else {
                    guard let warningReason = warningReason else { return }
                    guard let warningMessage = warningMessage else { return }
                    DispatchQueue.main.async {                    
                        completion(response, warningReason, warningMessage)
                    }
                }
            }
        }
    }
    
}
