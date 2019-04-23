//
//  BiometricRecognitionService.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/17/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

enum WarningReason: String {
    case hardwareUnavailable = "Biometry unavailable"
    case authenticationFail = "Authentication Failed"
}

enum WarningMessage: String {
    case hardwareUnavailable = "Your device is not configured for biometric authentication"
    case authenticationFail = "You could not be verified with TouchID; please try again."
    
    case authenticationFailed = "There was a problem verifying your identity."
    case userCancel = "You pressed cancel."
    case userFallback = "You pressed password."
    case biometryNotAvailable = "Face ID / Touch ID is not available."
    case biometryNotEnrolled = "Face ID / Touch ID is not set up."
    case biometryLockout = "Face ID / Touch ID is locked."
    case customeMessage = "Face ID / Touch ID may not be configured."
}

class BiometricRecognition {
    let authenticationContext = LAContext()
    var authError: NSError?
    let reason: String = "Loggin in With Touch ID"
    
    func canEvaluatePolicy() -> Bool {
        return authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authenticationContext.biometryType {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .none
        }
    }
    
    func authenticationProcess(completion: @escaping (Bool, String?) -> Void) {
        if #available(iOS 8.0, iOSMac 10.12.1, *) {
            guard canEvaluatePolicy() else {
                completion(false,"Touch ID / Face ID not available.")
                return
            }
            
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (loginSuccess, loginError) in
                if loginSuccess {
                    completion(loginSuccess,nil)
                } else {
                    let message: String
                    switch loginError {
                    case LAError.authenticationFailed?:
                        message = "There was a problem verifying your identity."
                    case LAError.userCancel?:
                        message = "You pressed cancel."
                    case LAError.userFallback?:
                        message = "You pressed password."
                    case LAError.biometryNotAvailable?:
                        message = "Face ID/Touch ID is not available."
                    case LAError.biometryNotEnrolled?:
                        message = "Face ID/Touch ID is not set up."
                    case LAError.biometryLockout?:
                        message = "Face ID/Touch ID is locked."
                    default:
                        message = "Face ID/Touch ID may not be configured"
                    }
                    
                    completion(false, message)
                }
            })
        }
    }
}
