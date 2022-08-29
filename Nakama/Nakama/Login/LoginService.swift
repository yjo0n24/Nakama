//
//  LoginService.swift
//  Nakama
//
//  Created by Yew Joon Wong on 28/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginService {
    
    func performSignIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(result, error)
        }
    }
}
