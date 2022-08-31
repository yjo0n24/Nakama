//
//  LoginPresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 27/08/2022.
//

import Foundation

// MARK: - Protocol
protocol LoginPresenterProtocol: AnyObject {
    func didValidateInput(isValid: Bool)
    func onSignInSuccess()
    func onError(errorMessage: String)
}

class LoginPresenter {
    
    // MARK: - Variables
    private let loginService: LoginService = LoginService()
    weak var delegate: LoginPresenterProtocol?
    
    // MARK: - Methods
    func validateInput(_ email: String, _ password: String) {
        let isValid = (email.isValidFormat(with: SharedConstants.RegEx.email) && !password.isEmpty)
        delegate?.didValidateInput(isValid: isValid)
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
