//
//  LoginViewModel.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/14/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class LoginViewModel {
    private let username: String = "admin"
    private let password: String = "admin"
    
    private enum LoginWarnings: String {
        case missedValue = "Username or Password dismissed."
        case mismatchValues = "Username or Password not Valid."
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
    
}
