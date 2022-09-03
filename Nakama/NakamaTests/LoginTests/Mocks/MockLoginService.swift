//
//  MockLoginService.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 03/09/2022.
//

import Foundation
@testable import Nakama

class MockLoginService: LoginService {
    
    var shouldFailRequest = false
    
    override func performSignIn(email: String, password: String, completion: @escaping (AuthModel?, Error?) -> Void) {
        guard !shouldFailRequest else {
            let error = NSError(domain: "", code: 500)
            completion(nil, error)
            return
        }
        
        var model = AuthModel()
        model.userId = "1"
        model.email = "tester@gmail.com"
        model.username = "username"
        
        completion(model, nil)
    }
}
