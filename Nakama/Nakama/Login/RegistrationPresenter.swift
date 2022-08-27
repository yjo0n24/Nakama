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
}

class RegistrationPresenter {
    
    // MARK: - Variables
    weak var delegate: RegistrationPresenterProtocol?
    
    // MARK: - Methods
    func validateInput(_ input1: String, _ input2: String?, stepType: RegistrationStepType) {
        switch stepType {
        case .username:
            delegate?.didValidateInput(isValid: !input1.isEmpty)
        case .email:
            delegate?.didValidateInput(isValid: input1.isValidFormat(with: SharedConstants.RegEx.email))
        case .password:
            if input1.isValidFormat(with: SharedConstants.RegEx.password) && input1 == input2 {
                delegate?.didValidateInput(isValid: true)
            } else {
                delegate?.didValidateInput(isValid: false)
            }
        }
    }
}
