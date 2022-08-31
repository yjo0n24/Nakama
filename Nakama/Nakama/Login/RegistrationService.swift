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
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = model.username
            //changeRequest.photoURL = ""
            
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    completion(nil, error)
                } else {
                    var resultModel = AuthModel()
                    resultModel.userId = user.uid
                    resultModel.username = model.username
                    resultModel.email = user.email ?? ""
                    UserDataHelper().setLoginInfo(resultModel)
                    
                    completion(model, nil)
                }
            })
        })
    }
}
