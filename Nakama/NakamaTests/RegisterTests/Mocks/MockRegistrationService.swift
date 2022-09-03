//
//  MockRegistrationService.swift
//  NakamaTests
//
//  Created by Yew Joon Wong on 04/09/2022.
//

import Foundation
@testable import Nakama

class MockRegistrationService: RegistrationService {
    
    var shouldFailRequest = false
    
    override func performSignUp(_ model: AuthModel, completion: @escaping (AuthModel?, Error?) -> Void) {
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
