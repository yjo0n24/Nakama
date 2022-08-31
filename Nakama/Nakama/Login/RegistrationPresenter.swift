//
//  RegistrationPresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation

// MARK: - Protocol
protocol RegistrationPresenterProtocol: AnyObject {
    func didValidateInput(isValid: Bool)
    func onSignUpSuccess()
    func onError(errorMessage: String)
}

class RegistrationPresenter {
    
    // MARK: - Variables
    private let registrationService: RegistrationService = RegistrationService()
    weak var delegate: RegistrationPresenterProtocol?
    
    // MARK: - Methods
    func validateUsername(_ username: String) {
        delegate?.didValidateInput(isValid: !username.isEmpty)
    }
    
    func validateCredentials(email: String, password: String, confirmPassword: String) {
        if !email.isValidFormat(with: SharedConstants.RegEx.email) {
            delegate?.didValidateInput(isValid: false)
            return
        }
        if !(password.isValidFormat(with: SharedConstants.RegEx.password) && password == confirmPassword) {
            delegate?.didValidateInput(isValid: false)
            return
        }
        delegate?.didValidateInput(isValid: true)
    }
    
    func performSignUp(username: String, email: String, password: String, profileImage: String?) {
        var model = AuthModel()
        model.username = username
        model.email = email
        model.password = password
        model.profileImage = profileImage
        
        registrationService.performSignUp(model, completion: { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let _ = result {
                self.delegate?.onSignUpSuccess()
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
