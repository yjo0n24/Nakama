//
//  MockRegistrationPresenter.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import Foundation
@testable import Nakama

class MockRegistrationPresenter: RegistrationPresenter {
    
    var shouldFailRequest = false
    
    override func validateUsername(_ username: String) {
        delegate?.onFormValidate(isValid: !shouldFailRequest)
    }
    
    override func validateCredentials(email: String, password: String, confirmPassword: String) {
        if shouldFailRequest {
            delegate?.onErrorValidateCredentials(errorTypes: [.emailInvalid])
        } else {
            delegate?.onFormValidate(isValid: true)
        }
    }
    
    override func performSignUp(username: String, email: String, password: String, imageData: Data?) {
        if shouldFailRequest {
            delegate?.onError(errorMessage: "Request failed")
        } else {
            delegate?.onSignUpSuccess()
        }
    }
}
