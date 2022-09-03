//
//  MockLoginVC.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 03/09/2022.
//

import Foundation
@testable import Nakama

class MockLoginVC: LoginPresenterProtocol {
    
    private var presenter: LoginPresenter!
    var onFormValidateCalled = false
    var onFormValidateCallbackValue = false
    var showEmailFormatErrorCalled = false
    var hideEmailFormatErrorCalled = false
    var onSignInSuccessCalled = false
    var onErrorCalled = false
    
    init(presenter: LoginPresenter) {
        presenter.delegate = self
    }
    
    func onFormValidate(isValid: Bool) {
        onFormValidateCalled = true
        onFormValidateCallbackValue = isValid
    }
    
    func showEmailFormatError(errorMessage: String) {
        showEmailFormatErrorCalled = true
    }
    
    func hideEmailFormatError() {
        hideEmailFormatErrorCalled = true
    }
    
    func onSignInSuccess() {
        onSignInSuccessCalled = true
    }
    
    func onError(errorMessage: String) {
        onErrorCalled = true
    }
}
