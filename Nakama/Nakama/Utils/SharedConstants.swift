//
//  SharedConstants.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation

struct SharedConstants {
    
    struct RegEx {
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let password = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$"
    }
    
    struct StoryboardName {
        static let login = "Login"
    }
    
    struct StoryboardId {
        static let loginVC = "LoginVC"
        static let registrationVC = "RegistrationVC"
    }
}
