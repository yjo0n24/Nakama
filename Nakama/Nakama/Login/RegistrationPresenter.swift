//
//  RegistrationPresenter.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation

// MARK: - Protocol
protocol RegistrationPresenterProtocol: AnyObject {
    func onFormValidate(isValid: Bool)
    func onSignUpSuccess()
    func onError(errorMessage: String)
    func onErrorValidateCredentials(errorTypes: [FormErrorType])
}

class RegistrationPresenter {
    
    // MARK: - Variables
    private let registrationService: RegistrationService!
    weak var delegate: RegistrationPresenterProtocol?
    
    // MARK: - Methods
    init(service: RegistrationService) {
        registrationService = service
    }
    
    func validateUsername(_ username: String) {
        delegate?.onFormValidate(isValid: !username.isEmpty)
    }
    
    func validateCredentials(email: String, password: String, confirmPassword: String) {
        var errorTypes = [FormErrorType]()
        
        // 1. Validate email format
        if !email.isValidFormat(with: SharedConstants.RegEx.email) {
            errorTypes.append(.emailInvalid)
        }
        
        // 2. Validate password format
        if !password.isValidFormat(with: SharedConstants.RegEx.password) {
            errorTypes.append(.passwordInvalid)
        } else {
            
        // 3. Validate password match
            if password != confirmPassword {
                errorTypes.append(.passwordMismatch)
            }
        }
        
        if errorTypes.isEmpty {
            delegate?.onFormValidate(isValid: true)
        } else {
            delegate?.onErrorValidateCredentials(errorTypes: errorTypes)
        }
    }
    
    func performSignUp(username: String, email: String, password: String, imageData: Data?) {
        if let imageData = imageData {
            FirebaseStorageHelper.shared.performSaveImage(
                imageData,
                refPath: SharedConstants.Firestore.Storage.users,
                completion: { [weak self] (imageUrl, error) in
                
                guard let self = self else { return }
                
                if let error = error {
                    self.delegate?.onError(errorMessage: error.localizedDescription)
                } else {
                    self.performSignUpService(username: username, email: email, password: password, profileImage: imageUrl)
                }
            })
        } else {
            performSignUpService(username: username, email: email, password: password, profileImage: nil)
        }
    }
    
    func performSignUpService(username: String, email: String, password: String, profileImage: String?) {
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
