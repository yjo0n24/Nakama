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
    
    func performSignIn(email: String, password: String, completion: @escaping (AuthModel?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                completion(nil, error)
                return
            }
            
            var model = AuthModel()
            model.userId = user.uid
            model.email = user.email ?? ""
            model.username = user.displayName ?? ""
            UserDataHelper().setLoginInfo(model)
            
            completion(model, error)
        }
    }
}
