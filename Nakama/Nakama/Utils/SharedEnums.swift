//
//  NakamaEnums.swift
//  Nakama
//
//  Created by Yew Joon Wong on 24/08/2022.
//

import Foundation

enum RegistrationStepType {
    case username
    case image
    case credentials
}

enum FormErrorType {
    case emailInvalid
    case passwordInvalid
    case passwordMismatch
}
