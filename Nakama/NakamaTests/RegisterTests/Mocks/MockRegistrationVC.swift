//
//  MockRegistrationVC.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import Foundation
@testable import Nakama

class MockRegistrationVC: RegistrationPresenterProtocol {
    
    private var presenter: RegistrationPresenter!
    var onFormValidateCalled = false
    var onFormValidateCallbackValue = false
    var onSignUpSuccessCalled = false
    var onErrorCalled = false
    var onErrorValidateCredentialsCalled = false
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        self.presenter.delegate = self
    }
    
    func onFormValidate(isValid: Bool) {
        onFormValidateCalled = true
        onFormValidateCallbackValue = isValid
    }
    
    func onSignUpSuccess() {
        onSignUpSuccessCalled = true
    }
    
    func onError(errorMessage: String) {
        onErrorCalled = true
    }
    
    func onErrorValidateCredentials(errorTypes: [FormErrorType]) {
        onErrorValidateCredentialsCalled = true
    }
}
