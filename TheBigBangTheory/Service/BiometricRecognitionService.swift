//
//  BiometricRecognitionService.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/17/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricRecognition {
    let authenticationContext = LAContext()
    var authError: NSError?
    let reason: String = "TouchID / FaceID Login"
    
    enum WarningReason: String {
        case hardwareUnavailable = "Biometry unavailable"
        case authenticationFail = "Authentication Failed"
    }
    
    enum WarningMessage: String {
        case hardwareUnavailable = "Your device is not configured for biometric authentication"
        case authenticationFail = "You could not be verified; please try again."
    }
    
    func authenticationProcess(completion: @escaping (Bool, String?, String?) -> Void) {
        if #available(iOS 8.0, iOSMac 10.12.1, *) {
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (loginSuccess, loginError) in
                    if loginSuccess {
                        completion(loginSuccess,nil,nil)
                    } else {
                        completion(false, WarningReason.authenticationFail.rawValue, WarningMessage.authenticationFail.rawValue)
                    }
                })
            } else {
                completion(false, WarningReason.hardwareUnavailable.rawValue, WarningMessage.hardwareUnavailable.rawValue)
            }
        }
    }
}
