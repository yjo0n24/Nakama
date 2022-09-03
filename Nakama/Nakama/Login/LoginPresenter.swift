//
//  LoginPresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import Foundation

// MARK: - Protocol
protocol LoginPresenterProtocol: AnyObject {
    func onFormValidate(isValid: Bool)
    func showEmailFormatError(errorMessage: String)
    func hideEmailFormatError()
    func onSignInSuccess()
    func onError(errorMessage: String)
}

class LoginPresenter {
    
    // MARK: - Variables
    private let loginService: LoginService!
    weak var delegate: LoginPresenterProtocol?
    
    // MARK: - Methods
    init(service: LoginService) {
        loginService = service
    }
    
    func validateInput(_ email: String, _ password: String) {
        var isValid = true
        
        // 1. Validate email format
        if !email.isValidFormat(with: SharedConstants.RegEx.email) {
            delegate?.showEmailFormatError(errorMessage: StringConstants.Registration.lblInvalidEmailError.localized)
            isValid = false
        } else {
            delegate?.hideEmailFormatError()
        }
        
        // 2. Validate password empty
        if password.isEmpty {
            isValid = false
        }
        
        delegate?.onFormValidate(isValid: isValid)
    }
    
    func performSignIn(email: String, password: String) {
        loginService.performSignIn(email: email, password: password, completion: { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let _ = result {
                self.delegate?.onSignInSuccess()
            } else {
                if let error = error {
                    self.delegate?.onError(errorMessage: error.localizedDescription)
                } else {
                    self.delegate?.onError(errorMessage: StringConstants.Error.msgGeneral)
                }
            }
        })
    }
}
