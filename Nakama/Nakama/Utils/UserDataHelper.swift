//
//  UserDataHelper.swift
//  Nakama
//
//  Created by Yew Joon Wong on 29/08/2022.
//

import Foundation

class UserDataHelper {
    
    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    // MARK: - Methods
    func setLoginInfo(_ model: LoginModel) {
        defaults.set(model.userId, forKey: SharedConstants.UserDefaultsKey.userId)
        defaults.set(model.email, forKey: SharedConstants.UserDefaultsKey.email)
        defaults.set(model.username, forKey: SharedConstants.UserDefaultsKey.username)
    }
    
    func getLoginInfo() -> LoginModel {
        let userId = defaults.string(forKey: SharedConstants.UserDefaultsKey.userId) ?? ""
        let email = defaults.string(forKey: SharedConstants.UserDefaultsKey.email) ?? ""
        let username = defaults.string(forKey: SharedConstants.UserDefaultsKey.username) ?? ""
        return LoginModel(userId: userId, email: email, username: username)
    }
    
    func deleteLoginInfo() {
        defaults.removeObject(forKey: SharedConstants.UserDefaultsKey.userId)
        defaults.removeObject(forKey: SharedConstants.UserDefaultsKey.email)
        defaults.removeObject(forKey: SharedConstants.UserDefaultsKey.username)
    }
}
