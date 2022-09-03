//
//  RegistrationService.swift
//  Nakama
//
//  Created by Yew Joon Wong on 31/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class RegistrationService {
    
    func performSignUp(_ model: AuthModel, completion: @escaping (AuthModel?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: model.email, password: model.password, completion: { (result, error) in
            guard let user = result?.user, error == nil else {
                completion(nil, error)
                return
            }
            
            // Add additional user info
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = model.username
            
            if let profileImageUrl = URL(string: model.profileImage ?? "") {
                changeRequest.photoURL = profileImageUrl
            }
            
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    completion(nil, error)
                } else {
                    var resultModel = AuthModel()
                    resultModel.userId = user.uid
                    resultModel.username = model.username
                    resultModel.email = user.email ?? ""
                    resultModel.profileImage = user.photoURL?.absoluteString
                    UserDataHelper().setLoginInfo(resultModel)
                    
                    completion(model, nil)
                }
            })
        })
    }
}
